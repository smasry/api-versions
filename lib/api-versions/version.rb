module ApiVersions
  MAJOR = 1
  MINOR = 4
  PATCH = 0
  PRE   = nil

  VERSION = [MAJOR, MINOR, PATCH, PRE].compact.join '.'
end
