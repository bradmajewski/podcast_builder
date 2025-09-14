module SFTP
  ERRORS = {
    (FX_OK                      = 0)  => "Operation successful",
    (FX_EOF                     = 1)  => "End of file",
    (FX_NO_SUCH_FILE            = 2)  => "No such file",
    (FX_PERMISSION_DENIED       = 3)  => "Permission denied",
    (FX_FAILURE                 = 4)  => "Failure",
    (FX_BAD_MESSAGE             = 5)  => "Bad message",
    (FX_NO_CONNECTION           = 6)  => "No connection",
    (FX_CONNECTION_LOST         = 7)  => "Connection lost",
    (FX_OP_UNSUPPORTED          = 8)  => "Operation unsupported",
    (FX_INVALID_HANDLE          = 9)  => "Invalid handle",
    (FX_NO_SUCH_PATH            = 10) => "No such path",
    (FX_FILE_ALREADY_EXISTS     = 11) => "File already exists",
    (FX_WRITE_PROTECT           = 12) => "Write protect",
    (FX_NO_MEDIA                = 13) => "No media",
    (FX_NO_SPACE_ON_FILESYSTEM  = 14) => "No space on filesystem",
    (FX_QUOTA_EXCEEDED          = 15) => "Quota exceeded",
    (FX_UNKNOWN_PRINCIPLE       = 16) => "Unknown principle",
    (FX_LOCK_CONFLICT           = 17) => "Lock conflict",
    (FX_DIR_NOT_EMPTY           = 18) => "Directory not empty",
    (FX_NOT_A_DIRECTORY         = 19) => "Not a directory",
    (FX_INVALID_FILENAME        = 20) => "Invalid filename",
    (FX_LINK_LOOP               = 21) => "Link loop",
  }

  TYPES = {
    (T_REGULAR      = 1) => "regular",
    (T_DIRECTORY    = 2) => "directory",
    (T_SYMLINK      = 3) => "symlink",
    (T_SPECIAL      = 4) => "special",
    (T_UNKNOWN      = 5) => "unknown",
    (T_SOCKET       = 6) => "socket",
    (T_CHAR_DEVICE  = 7) => "char_device",
    (T_BLOCK_DEVICE = 8) => "block_device",
    (T_FIFO         = 9) => "fifo",
    # Pseudo Types:
    # - "not_found"
    # - "permission_denied"
  }
end
