using DrWatson
@quickactivate

struct File
	name::String
	size::Int
end

struct Directory
	parent::Union{Directory,Nothing}
	children::Dict{String, Union{Directory, File}}
	name::String
end

global current::Directory = Directory(nothing, Dict{String, Union{Directory, File}}(), "/")
global root = current

function cd_(s)
	global current
	if s == "/"
		current = root
		return
	end
	if s == ".."
		current = current.parent
		return
	end
	if haskey(current.children, s)
		current = current.children[s]
	else
		current.children[s] = Directory(current, Dict{String, Union{Directory, File}}(), s)
		current = current.children[s]
	end
end

function process_command(s)
	sp = split(s)
	if sp[2] == "cd"
		cd_(sp[3])
	end
end

function process_data(s)
	sp = split(s)
	if sp[1] == "dir"
		di = Directory(current, Dict{String, Union{Directory, File}}(), sp[2])
		current.children[sp[2]] = di
	else
		size = parse(Int, sp[1])
		name = sp[2]
		fi = File(name, size)
		current.children[name] = fi
	end
end

function process_text(s)
	command = (s[1] == '$')
	if command
		process_command(s)
	else
		process_data(s)
	end
end

function size_(d::Union{Directory, File})
	if typeof(d) == File
		return d.size
	end
	if length(values(d.children)) == 0
		return 0
	end
	return sum(size_.(values(d.children)))
end

f = datadir("input", "7.txt")
process_text.(eachline(f))

count = 0
dirs = []
function size_dir(d::Directory)
	global count
	sd = size_(d)
	push!(dirs, sd)
	if sd <= 100000
		println(d.name)
		count += sd
	end
	size_dir.(filter(y -> typeof(y) == Directory, collect(values(d.children))))
	return
end
size_dir(root)
println(count)

root_size = size_(root)
needed = 30000000 - (70000000 - root_size)
println(minimum(filter(x -> x >= needed, dirs)))
