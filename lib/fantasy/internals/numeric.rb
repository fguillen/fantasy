class Numeric
  def copysign(sign_source)
    sign_source < 0 ? -abs : abs
  end

  def sign
    return 1 if positive?
    return -1 if negative?

    0
  end
end
