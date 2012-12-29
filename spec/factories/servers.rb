FactoryGirl.define do
	sequence :hostname do |n|
		name = ('a'..'z').to_a.shuffle(:random => Random.new)[0,10].join
		"www.#{name}.com"
	end

	sequence :ip_address do |n|
		(0..255).to_a.shuffle(:random => Random.new)[0,4].join(".")
	end

	factory :dynamic_server, :class => Server do
		hostname
		ip_address
	end
end