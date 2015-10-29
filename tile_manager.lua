tiles = {}
images = {}
sprite_batches = {}

function load_images()
    images["ground"] = love.graphics.newImage("images/tile_ground.png")

    for i,image in pairs(images) do
    	image:setFilter("nearest", "linear") -- this "linear filter" removes some artifacts if we were to scale the tiles
    	sprite_batches[i] = love.graphics.newSpriteBatch(images[i],images[i]:getWidth()*images[i]:getHeight())
    end
end

function identify_tile(r,g,b,a)
	if r==0 and g==0 and b==0 and a==255 then
		return "ground"
	end
end

level_map = nil
-- function that should only be used for placing ground in load_level
function gcheck(x,y)
	return identify_tile(level_map:getPixel(x,y)) == "ground"
end

function load_level(name)
    level_map = love.image.newImageData('maps/'..name..'.png');
    level_width = level_map:getWidth()
    level_height = level_map:getHeight()

    for lx = 0,level_width-1 do
        for ly = 0,level_height-1 do
            type = identify_tile(level_map:getPixel(lx,ly))

            if type == "ground" then

            	pos = {1,1}

            	-- which ground tile to show? (ROW, COLUMN)

            	-- vertical block
            	if gcheck(lx,ly+2) then
            		pos = {2,1}
            		if ly >= 2 and gcheck(lx,ly-2) then
            			pos = {3,1}
            		end
            	elseif ly >= 2 and gcheck(lx,ly-2) then
            		pos = {4,1}
            	end

            	--horizontal block
            	if gcheck(lx+2,ly) then
            		pos = {4,2}
            		if lx >= 2 and gcheck(lx-2,ly) then
            			pos = {4,3}
            		end
            	elseif lx >= 2 and gcheck(lx-2,ly) then
            		pos = {4,4}
            	end

            	--box block
            	if gcheck(lx+2,ly) then
            		if gcheck(lx,ly+2) then
            			pos = {1,2}
            		end
            		if ly >= 2 and gcheck(lx,ly+2) and gcheck(lx,ly-2) then
            			pos = {2,2}
            		end
            		if ly >= 2 and gcheck(lx,ly-2) then
            			pos = {3,2}
            		end
            	elseif lx >= 2 and gcheck(lx-2,ly) then
            		if gcheck(lx,ly+2) then
            			pos = {1,4}
            		end
            		if lx >= 2 and gcheck(lx,ly+2) and gcheck(lx,ly-2) then
            			pos = {2,4}
            		end
            		if ly >= 2 and gcheck(lx,ly-2) then
            			pos = {3,4}
            		end
            	end


                sprite_batches["ground"]:add(
                	love.graphics.newQuad((pos[2]-1)*33,(pos[1]-1)*33, 33, 33,images["ground"]:getWidth(), images["ground"]:getHeight()),
                	lx*16,ly*16)

                table.insert(tiles,{"ground",lx*16,ly*16,pos[1],pos[2]})
            end
        end
    end

    for b,batch in pairs(sprite_batches) do
    	batch:flush()
    end

end

function draw_level()
    for b,batch in pairs(sprite_batches) do
        love.graphics.draw(batch)
    end
end