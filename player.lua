Player = class('Player')


function Player:initialize(x,y)
	self.x = x
	self.y = y
	self.currentAnimation = "stand"

	self.images = {
		["stand"]	=love.graphics.newImage("images/player/player_stand.png"),
		["walk"]	=love.graphics.newImage("images/player/player_walk.png"),
		["die"]		=love.graphics.newImage("images/player/player_die.png")
	}
	
	self.animations = {
		["stand"]=anim8.newAnimation(
					anim8.newGrid(18,35,self.images["stand"]:getWidth(),self.images["stand"]:getHeight())(1,1),0.1),
		["walk"]=anim8.newAnimation(
					anim8.newGrid(17,33,self.images["walk"]:getWidth(),self.images["walk"]:getHeight())('1-2',1),0.1),
		["die"]=anim8.newAnimation(
					anim8.newGrid(35,35,self.images["die"]:getWidth(),self.images["die"]:getHeight())(1,1),0.1)
	}

end

function Player:update(dt)
	self.animations[self.currentAnimation]:update(dt)
end

function Player:draw()
	x_offset = 18
	y_offset = 35/2
	self.animations[self.currentAnimation]:draw(self.images[self.currentAnimation],self.x+x_offset,self.y+y_offset)
end