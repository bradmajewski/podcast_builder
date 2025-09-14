require "test_helper"

class SFTPClientTest < ActiveSupport::TestCase
  test "connects to SFTP server" do
    sftp = SFTP::Client.new(servers(:dev))
    sftp.start do |s|
      assert_equal s.file_type("test"), "not_found", "Previous test data was not cleared."
    end
  end
end
