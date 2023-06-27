require "spec"
require "http/headers"
require "./parser.cr"

describe "HTTP Parser" do
  describe "#read_request_line" do
    it "correctly parses valid request line" do
      request_line = IO::Memory.new "GET / HTTP/1.1"
      read_request_line(request_line).should eq RequestLine.new method: "GET", path: "/"
    end

    it "correctly catches empty request line" do
      error = "This request looks empty. Are you sure you have anything typed into BODY?"
      expect_raises(Exception, error) do
        read_request_line(IO::Memory.new "")
      end

      expect_raises(Exception, error) do
        read_request_line(IO::Memory.new "\n")
      end
    end

    it "correctly checks for 3 arguments" do
      error = "Your request header does not have 3 arguments. Remember that a request header is <method> <path> <protocol>."
      expect_raises(Exception, error) do
        read_request_line(IO::Memory.new "GET")
      end

      expect_raises(Exception, error) do
        read_request_line(IO::Memory.new "GET /")
      end

      expect_raises(Exception, error) do
        read_request_line(IO::Memory.new "GET / HTTP/1.1 BUTMORE")
      end

      expect_raises(Exception, error) do
        read_request_line(IO::Memory.new "GET / NOT CORRECT AT ALL")
      end
    end

    it "correctly validates 3 arguments" do
      expect_raises(Exception, "NONEXISTANT does not seem to be a valid http method. Make sure that your method is ALL CAPS. All methods can be found here https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods") do
        read_request_line(IO::Memory.new "NONEXISTANT / HTTP/1.1")
      end

      expect_raises(Exception, "non_existant is an invalid path. Make sure that your path starts with a slash ( / )") do
        read_request_line(IO::Memory.new "GET non_existant HTTP/1.1")
      end

      expect_raises(Exception, "Minecraft/1.19 is not a valid http protocol accepted by this server, make sure your protocol is HTTP/1.0 or HTTP/1.1") do
        read_request_line(IO::Memory.new "GET / Minecraft/1.19")
      end
    end
  end

  describe "#get_challenge" do
    it "accepts_valid" do
      get_challenge((RequestLine.new method: "GET", path: "/0-welcome"), HTTP::Headers.new)
      get_challenge((RequestLine.new method: "GET", path: "/5-common-headers"), HTTP::Headers{"Hello" => "World"})
    end

    it "correctly catches invalid paths" do
      error = "All paths in this gauntlet are formatted as /<id>-<key>, for example /0-welcome. 0 would be the id and welcome would be the key. Make sure that you typed the URL correctly"
      expect_raises(Exception, error) do
        get_challenge((RequestLine.new method: "GET", path: "abcdef"), HTTP::Headers.new)
      end

      expect_raises(Exception, error) do
        get_challenge((RequestLine.new method: "GET", path: "/abcdef"), HTTP::Headers.new)
      end


    end

    it "correctly catches non-number id" do
      error = "All paths in this gauntlet are formatted as /<id>-<key>, for example /0-welcome. It seems that your id is not a number. Double check that your id is a number."
      expect_raises(Exception, error) do
        get_challenge((RequestLine.new method: "GET", path: "/abc-def"), HTTP::Headers.new)
      end
      expect_raises(Exception, error) do
        get_challenge((RequestLine.new method: "GET", path: "/ab-c-def"), HTTP::Headers.new)
      end
    end

    it "correctly catches incorrect key" do
      expect_raises(Exception, "All paths in this gauntlet are formatted as /<id>-<key>, for example /0-welcome. It seems that your key is incorrect. Make sure that you typed in the path correctly") do
        get_challenge((RequestLine.new method: "GET", path: "/0-abc"), HTTP::Headers.new)
      end
    end

    it "correctly catches incorrect method" do
      expect_raises(Exception, "Make sure your method is correct. the correct method to use is GET but you sent NONEXISTANT.") do
        get_challenge((RequestLine.new method: "NONEXISTANT", path: "/0-welcome"), HTTP::Headers.new)
      end
    end
  end
end
