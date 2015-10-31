Player = class('Player')


function Player:initialize(x,y)
	self.x = x+18
	self.y = y+(35/2)
	self.x_offset=4.5
	self.y_offset=0
	self.currentAnimation = "stand"
	self.direction = 'R'

	self.rect = hc.rectangle(self.x,self.y,18,35)
	self.collisions = {}

	self.dx = 100

	self.images = {
		["stand"]	=love.graphics.newImage("images/player/player_stand.png"),
		["walk"]	=love.graphics.newImage("images/player/player_walk.png"),
		["die"]		=love.graphics.newImage("images/player/player_die.png")
	}
	
	basic_animations = {
		["stand"]=anim8.newAnimation(
					anim8.newGrid(18,35,self.images["stand"]:getWidth(),self.images["stand"]:getHeight())(1,1),0.1),
		["walk"]=anim8.newAnimation(
					anim8.newGrid(17,33,self.images["walk"]:getWidth(),self.images["walk"]:getHeight())('1-2',1),0.1),
		["die"]=anim8.newAnimation(
					anim8.newGrid(35,35,self.images["die"]:getWidth(),self.images["die"]:getHeight())(1,1),0.1)
	}

	self.animations = {}
	-- created flipped versions of animations
	for a,animation in pairs(basic_animations) do
		self.animations[a..'R'] = basic_animations[a]
		self.animations[a..'L'] = basic_animations[a]:clone():flipH()
		print(a..'R '..a..'L')
	end

end

function Player:update(dt)
	-- check for collisions
	self.collisions = hc.collisions(self.rect)
	other_ground = nil
	for other, separating_vector in pairs(self.collisions) do
	    x1, y1, x2, y2 = other:bbox()
	    other_ground = {other,x1,y1,x2,y2}

	    hspeed = self.dx*dt

		-- move RIGHT
		if love.keyboard.isDown("right") and not love.keyboard.isDown("left") then
			self.rect:move(hspeed,0)

			self.direction = 'R'
			self.x_offset = 4.5

		-- move LEFT
		elseif love.keyboard.isDown("left") and not love.keyboard.isDown("right") then
			self.rect:move(-hspeed,0)

			self.direction = 'L'
			self.x_offset = 0

		end

		-- move hitbox
	    self.rect:move(separating_vector.x,0)
	    x,y = self.rect:center()
	    self.x = x-9-self.x_offset
	    self.y = y-(33/2)
	end

	self.animations[self.currentAnimation..self.direction]:update(dt)
end

function Player:draw()
	self.animations[self.currentAnimation..self.direction]:draw(self.images[self.currentAnimation],self.x+self.x_offset,self.y)

	love.graphics.setColor(0,0,0,255)
	self.rect:draw()
	for other,sep_vector in pairs(self.collisions) do
		other:draw()
	end
	love.graphics.setColor(255,255,255,255)
end