level_map = nil
tiles = {}

images = {}
sprite_batches = {}

function load_level(name)
    level_file = love.filesystem.newFile(name..'.lua','r');
    level_map = loadstring(level_file:read())()
    level_file:close()

    -- load images and create sprite batches
    for i,image in pairs(level_map["tilesets"]) do
        name = image["name"]

        -- name, width, height, rows, columns
    	images[name] = {love.graphics.newImage(image["image"]),
                        image["tilewidth"],
                        image["tileheight"],
                        image["imagewidth"]/image["tilewidth"],
                        image["imageheight"]/image["tileheight"]}
        sprite_batches[name] = love.graphics.newSpriteBatch(images[name][1],
                                                            images[name][1]:getWidth()*images[name][1]:getHeight())
    end

    -- add tiles to sprite batches
    for l,layer in pairs(level_map["layers"]) do
        if layer["type"] == "tilelayer" then
            for t,tile in pairs(layer["data"]) do
                name = layer["name"]
                img_width = images[name][2]
                img_height = images[name][3]
                map_width = layer["width"]
                map_height= layer["height"]

                
                if tile > 0 then
                    -- get tile position
                    pos = {t,0}
                    if t > map_width then
                        pos[1] = t-(math.floor((t/map_width))*map_width)

                        pos[2] = math.floor(t/map_width)
                    end

                    -- get row and column of sprite quad
                    t_width = images[name][2]
                    t_height = images[name][3]
                    t_rows = images[name][4]
                    t_columns = images[name][5]-1

                    row = 0
                    col = tile-1
                    if tile > t_columns then
                        row = math.floor((tile-1)/t_columns) --fine and working
                        col = (tile-1)-(math.floor((tile-1)/t_columns)*t_columns)
                    end

                    sprite_batches[name]:add(
                        love.graphics.newQuad( (col*t_width), row*t_height, img_width, img_height, images[name][1]:getDimensions()),
                        pos[1]*(level_map["tilewidth"]),
                        pos[2]*(level_map["tileheight"])
                        )

                    table.insert(tiles,{name,pos[1],pos[2]})

                end
            end
        elseif layer["type"] == "objectgroup" then
            if layer["name"] == "player" then
                -- spawn player
                x = layer["objects"][1]["x"]
                y = layer["objects"][1]["y"]
                player = Player:new(x,y)
            end
        end
    end

    --[[
    sprite_batches["ground"]:add(
    	love.graphics.newQuad((pos[2]-1)*33,(pos[1]-1)*33, 33, 33,images["ground"]:getWidth(), images["ground"]:getHeight()),
    	(lx/2)*16,(ly/2)*16)

    table.insert(tiles,{"ground",(lx/2)*16,(ly/2)*16,pos[1],pos[2]})

    for b,batch in pairs(sprite_batches) do
    	batch:flush()
    end
    ]]--

end

function draw_level()
    for b,batch in pairs(sprite_batches) do
        love.graphics.draw(batch)
    end
end