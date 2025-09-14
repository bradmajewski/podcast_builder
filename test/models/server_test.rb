require "test_helper"

class ServerTest < ActiveSupport::TestCase

  test "Verify can connect to servers(dev) fixture" do
    server = servers(:dev)
    success, message = server.test_connection
    assert_nil message
    assert success
  end
end
