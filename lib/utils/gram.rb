# example
# input: str = "castle", n = 3
# output: ["$ca", "cas", "ast", "stl", "tle", "le$"]
def gram(str, n = 3)
  if n < 2: raise "n argument should be greater or equal 2" end
  prev = "$" + str[0..n-2]
  result = [prev]
  str = str[n-1..-1]
  # if n < str.length we have no string left
  if str: str << "$" else str = "$" end
  str.each_char do |c|
    # Drop first char and append c
    prev = prev[1..-1] + c
    result << prev
  end
  return result
end
