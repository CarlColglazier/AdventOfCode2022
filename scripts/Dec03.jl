using DrWatson
@quickactivate

function priority(letter)
	if isuppercase(letter)
		return Int(letter) - Int('A') + 27
	end
	return Int(letter) - Int('a') + 1
end

function process_line(l)
	n = length(l)
	chrs = collect(l)
	s = intersect(Set(chrs[1:Int(n/2)]), Set(chrs[Int(n/2) + 1:n]))
	letter = first(s)
	return priority(letter)
end


f = datadir("input", "3.txt")
count = 0
for line in eachline(f)
	p = process_line(line)
	count = count + p
end
println(count)

# part 2
lines = readlines(f)
count = 0
for i in 1:3:length(lines)
	s = intersect(
		Set(collect(lines[i])),
		Set(collect(lines[i+1])),
		Set(collect(lines[i+2]))
	)
	count = count + priority(first(s))
end
println(count)
