# monkey patch a few methods
class String
  # Output colors
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def titleize
    gsub(/\b./, &:upcase)
  end
end
