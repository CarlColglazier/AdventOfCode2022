using DrWatson
@quickactivate

mutable struct Monkey
	id::Int
	items::Array{BigInt}
	operation::String
	test::Int
	throw::Array{Int}
	inspections::Int
end

function build_monkeys(lines::Array{String})::Array{Monkey}
	monkey_ids = parse.(Int, [filter(isdigit, s) for s in lines[1:7:length(lines)]])
	items = [parse.(BigInt, x) for x in split.(strip.(last.(split.(lines[2:7:length(lines)], ':'))), ", ")]
	operations = last.(split.(lines[3:7:length(lines)], ": "))
	test = parse.(Int, [filter(isdigit, s) for s in lines[4:7:length(lines)]])
	t_throw = parse.(Int, [filter(isdigit, s) for s in lines[5:7:length(lines)]])
	f_throw = parse.(Int, [filter(isdigit, s) for s in lines[6:7:length(lines)]])
	monkeys = []
	for i in 1:length(monkey_ids)
		push!(monkeys, Monkey(monkey_ids[i], items[i], operations[i], test[i], [f_throw[i], t_throw[i]], 0))
	end
	return monkeys
end

function run!(monkeys::Array{Monkey}, i::Int; relief::Int=0)
	monkey = monkeys[i]
	while length(monkey.items) > 0
		old::BigInt = popfirst!(monkey.items)
		monkey.inspections += 1
		new::BigInt = 0
		item::BigInt = Meta.eval(Meta.parse(replace(monkey.operation, "old"=>"$old")))
		if relief == 0
			item = map(x -> x ÷ 3, item)
		else
			item = item % relief
		end
		if item % monkey.test == 0
			push!(monkeys[monkey.throw[2]+1].items, item)
		else
			push!(monkeys[monkey.throw[1]+1].items, item)
		end
	end
end


f = datadir("input", "11.txt")
monkeys = build_monkeys(collect(eachline(f)))
for _ in 1:20
	for i in eachindex(monkeys)
		run!(monkeys, i)
	end
end
println(reduce(*, sort([x.inspections for x in monkeys]; rev=true)[1:2]))

# part 2
monkeys = build_monkeys(collect(eachline(f)))
relief = reduce(*, [x.test for x in monkeys])
for _ in 1:10_000
	for i in eachindex(monkeys)
		run!(monkeys, i; relief=relief)
	end
end
println(reduce(*, sort([x.inspections for x in monkeys]; rev=true)[1:2]))
