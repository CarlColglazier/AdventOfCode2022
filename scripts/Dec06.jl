using DrWatson
@quickactivate

f = datadir("input", "6.txt")
data = readline(f)

for i in 1:length(data)-3
	if length(Set(data[i:i+3])) == 4
		println(i+3)
		break
	end
end

# part 2
for i in 1:length(data)-13
	if length(Set(data[i:i+13])) == 14
		println(i+13)
		break
	end
end
