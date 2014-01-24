class HanoiGame
	attr_reader :towers

	def initialize
		puts "*" * 34
		puts "* WELCOME TO THE TOWERS OF HANOI *"
		puts "*" * 34
		print "\nPlease input number of disks: "

		@number_of_disks = gets.chomp.to_i
		@towers = [Tower.new(@number_of_disks), Tower.new(0), Tower.new(0)]
	end

	def play
		until game_win? do
			show_gamestate 
			
			puts "Which tower would you like to take a disk from? (1, 2, or 3)"
			take = gets.chomp.to_i - 1
			puts "where would you like to place it? (1, 2, or 3)"
			give = gets.chomp.to_i - 1

			can_move?(take, give) ? move_disk(take, give) : (puts "\n**Invalid Move!**")
		end

		puts "*" * 34
		puts "*   CONGRATULATIONS, YOU WIN!    *"
		puts "*" * 34
		show_gamestate
	end


	private

	def move_disk(from_tower, to_tower)
		if can_move?(from_tower, to_tower)
			moved_disk = @towers[from_tower].take_disk
			@towers[to_tower].place_disk(moved_disk)
		end
		return self
	end

	def can_move?(from_tower, to_tower)
		return false if @towers[from_tower].disks.empty?
		return true if @towers[to_tower].disks.empty?

		from_tower_size = @towers[from_tower].disks.last.size
		to_tower_size = @towers[to_tower].disks.last.size
		from_tower_size < to_tower_size
	end

	def game_win?
		if @towers[0].disks.empty? && @towers[1].disks.empty?
			disks = @towers[2].show_disks
			disks == disks.sort.reverse
		else
			false
		end
	end

	def show_gamestate
		towers = @towers.map(&:show_disks)
		towers.map do |tower|
			@number_of_disks.times do |dex|
				if tower[dex].nil?
					tower[dex] = 0
				end
			end
		end
		gamestate = ''
		towers.transpose.reverse.each do |level|
			gamestate += "#{level.join('   ').center(34)}\n"
		end
		gamestate += "T1  T2  T3".center(34)
		puts "\n#{gamestate}\n\n"
	end


	class Disk
		attr_reader :size

		def initialize(size)
			@size = size
		end
	end


	class Tower
		attr_reader :disks

		def initialize(number_of_disks)
			@disks = setup_disks(number_of_disks)
		end

		def take_disk
			@disks.pop
		end

		def place_disk(disk)
			@disks << disk
		end

		def show_disks
			@disks.map(&:size)
		end

		def setup_disks(number_of_disks)
			disks = []
			number_of_disks.downto(1) do |disk|
				disks << Disk.new(disk)
			end
			disks
		end
	end
end


h = HanoiGame.new
h.play






