module ApiVersions
  MAJOR = 1
  MINOR = 4
  PATCH = 2
  PRE   = nil

  VERSION = [MAJOR, MINOR, PATCH, PRE].compact.join '.'
end
