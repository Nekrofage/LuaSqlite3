-- Lua Sqlite3 
--
-- Documentation; http://lua.sqlite.org/index.cgi/doc/tip/doc/lsqlite3.wiki
--


sqlite3 = require("lsqlite3")

databaseName = "mt_gandi.sqlite3"

function initDatabase()
    local db = sqlite3.open(databaseName)
    db:exec[[
      CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT,  
                         firstname CHAR(32),
                         lastname CHAR(32),
                         nickname CHAR(32)
                        );
      CREATE TABLE server (id INTEGER PRIMARY KEY,
                           hostname CHAR(32),
                           ipv4 CHAR(32),
                           ipv6 CHAR(32),
			   posx INTEGER,
			   posy INTEGER,
			   posz INTEGER
    ]]
    db:close()
end

-- Lua CRUD method


function insertServer(id, hostname, ipv4, ipv6, posx, posy, posz)
    local db = sqlite3.open(databaseName)
    local stmt = db:prepare[[ INSERT INTO server VALUES (:id, :hostname, :ipv4, :ipv6, :posx, :posy, :posz) ]]
    stmt:bind_names{  id = id,  hostname = hostname, ipv4 = ipv4, ipv6 = ipv6, posx = posx, posy = posy, posz = posz }
    stmt:step()
    stmt:finalize()
    db:close()
end



function selectServer()
    local db = sqlite3.open(databaseName)
    for row in db:nrows("SELECT * FROM server") do
      print(row.id, row.hostname, row.ipv4)
      end 
    db:close()

end


-- Lua CRUD method
function insertUser(firstname, lastname, nickname)
    local db = sqlite3.open(databaseName)
    local stmt = db:prepare[[ INSERT INTO user VALUES (null, :firstname, :lastname, :nickname) ]]
    stmt:bind_names{ firstname = firstname, lastname = lastname, nickname = nickname  }
    stmt:step()
    stmt:finalize()
    db:close()
end

function selectUser()
    local db = sqlite3.open(databaseName)
    for row in db:nrows("SELECT * FROM user") do
      print(row.id, row.firstname, row.lastname, row.nickname)
      end 
    db:close()
end


function updateUser(id, field, value)
    local db = sqlite3.open(databaseName)
    if field == "nickname" then
        local stmt = db:prepare[[ UPDATE user SET  nickname = :value WHERE id = :id ]]
        stmt:bind_names{  id = id,  value = value  }
        stmt:step()
        stmt:finalize()
    end
    db:close()
end


function deleteUser(id)
    local db = sqlite3.open(databaseName)
    local stmt = db:prepare[[ DELETE FROM user WHERE id = :id ]]
    stmt:bind_names{  id = id }
    stmt:step()
    stmt:finalize()
    db:close()
end


function seperator()
    print("-----------------------")
end

-- Init database
initDatabase()


-- Insert data
insertUser("Solomon", "Kane", "Nekrofage")
insertUser("Samuel", "Gondouin", "LeSanglier")
insertUser("Black", "Metal", "Nekros")

seperator()

-- Select user
selectUser()

seperator()

-- Update User
updateUser(2, "nickname", "Samglux")

seperator()

-- Select user
selectUser()

seperator()

-- Delete user
deleteUser(3)

seperator()

-- Select user
selectUser()

seperator()
