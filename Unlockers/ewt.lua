-- EWT API used by BadRotations

------------------------- Active Player -------------------

--- Set the direction that the player is facing.
-- Direction (number) or Object (string) - The direction in radians or the object
-- Update    (boolean) - Whether to immediately notify the server
-- Note1: You can also do FaceDirection(X, Y, Update) - The Z coordinate isnt needed.
-- Note2: Direction must be between [0,2pi] otherwise you will disconnect.
function FaceDirection (Direction[, Update])

--- Get the current map ID, area/zone ID and the sub-zone ID
-- return (number, number, number)
-- Examples:
-- Area/Zone = Elwynn Forest    (GetZoneText)
-- SubZone   = Goldshire        (GetSubZoneText)
function GetMapId()

------------------------- Object --------------------------

--- Get an object's pointer.
-- Object  (object) - The object
-- returns (string or nil) - The pointer as a hexadecimal string prefixed by 0x or nil if the object does not exist.
-- Note: If the object doesn't exist, for example, ObjectPointer('party1target'), it returns nil.
-- This API is mainly useful to get the object address of unitIDs like 'target', 'mouseover', etc.
-- ObjectPointer('0xDEADBEEF') simply returns '0xDEADBEEF' and does NOT check if the address exists in the object manager. Don't do this.
function ObjectPointer (Object)

--- Get whether an object exists in the object manager with O(n) performance.
-- Object  (object)  - The object
-- returns (string or nil) - The pointer as a hexadecimal string prefixed by 0x or nil if the object does not exist.
-- Note that if the object does not exist in the object manager it is invalid and should not be used.
-- This API has O(n) performance, which means that the more objects in the object manager, the slower it is.
-- This API is only useful to check if '0x' strings are *really* valid. It should never be used
-- if you are properly using GetObjectCount since you will always work with objects that exist.
-- This API is similar to ObjectPointer, but it checks if the object exists in the object manager.
-- If you pass a unitID, like ObjectExists('target'), then its performance is the same as ObjectPointer('target').
function ObjectExists (Object)

--- Get whether an object exists in the object manager with O(1) performance.
-- Object  (object)  - The object
-- returns (string or nil) - The pointer as a hexadecimal string prefixed by 0x or nil if the object does not exist.
-- Note: If you pass an invalid object, this will generate a crash log.
-- This API works like WoW's UnitIsVisible, but instead of returning boolean, it returns string or nil.
-- UnitIsVisible only applies to Units while ObjectIsVisible applies to all object types.
-- ObjectIsVisible has O(1) performance, which means that, no matter how many units in the object manager, the speed is the same.
-- ObjectIsVisible/UnitIsVisible may create crash logs if you provide '0x' strings of objects that don't exist.
function ObjectIsVisible (Object)

--- Get an object's position.
-- Object  (object)                 - The object
-- GetRaw  (boolean)                - Whether it should return the raw values as well. Useful for transport debugging.
-- returns (number, number, number) - The X, Y, and Z coordinates
-- Note: If the object doesn't exist, it returns (nil, nil, nil)
-- Note2: When in a transport, the raw position is relative to the transport's matrix.
function ObjectPosition (Object [, GetRaw])

--- Get an object's facing and display facing.
-- Object  (object)         - The object
-- GetRaw  (boolean)        - Whether it should return the raw value as well. Useful for transport debugging.
-- returns (number, number) - The facing (angle in XY) and display facing in radians between 0 and 2PI.
-- Note: If the object doesn't exist, it returns nil.
-- Note2: When in a transport, the raw facing is relative to the transport's facing.
function ObjectFacing (Object [, GetRaw])
GetObjectFacing = ObjectFacing

--- Get an object's GUID.
-- Object  (object) - The object
-- returns (string or nil) - The GUID as a string or nil if the object doesn't exist.
-- Note: This API is mainly for WoW Classic 1.12.1, because UnitGUID doesn't exist in this version
-- and to retrieve the GUID of GameObjects with the "mouseover" token.
function ObjectGUID (Object)

--- Get an object's name.
-- Object  (object) - The object
-- returns (string) - The name
function ObjectName (Object)

--- Get an object's type ID.
-- Object  (object)  - The object
-- returns (integer) - The type ID or nil if the object is invalid
function ObjectID (Object)

--- Get an object's type.
-- Object  (object)  - The object
-- returns (integer) - One member of the ObjectType table.
function ObjectRawType (Object)

function ObjectIsUnit(object)
    local type = ObjectRawType(object)
    return type == ObjectType.Unit or type == ObjectType.Player or type == ObjectType.ActivePlayer
end

function GetDistanceBetweenPositions (X1, Y1, Z1, X2, Y2, Z2)
    return math.sqrt(math.pow(X2 - X1, 2) + math.pow(Y2 - Y1, 2) + math.pow(Z2 - Z1, 2));
end

--- Get the distance between two objects.
-- Object1 (object) - The first object
-- Object2 (object) - The second object
-- returns (number) - The distance
function GetDistanceBetweenObjects (Object1, Object2)

--- Get the angles between two objects.
-- Object1 (object)         - The first object
-- Object2 (object)         - The second object
-- returns (number, number) - The facing (angle in XY) and pitch (angle from XY) from the first object to the second
function GetAnglesBetweenObjects (Object1, Object2)

--- Get the position that is between two objects and a specified distance from the first object.
-- Object1  (object)                 - The first object
-- Object2  (object)                 - The second object
-- Distance (number)                 - The distance from the first object
-- returns  (number, number, number) - The X, Y, and Z coordinates
function GetPositionBetweenObjects (Object1, Object2, Distance)

function GetPositionFromPosition (X, Y, Z, Distance, AngleXY, AngleXYZ)
    return math.cos(AngleXY) * Distance + X,
    math.sin(AngleXY) * Distance + Y,
    math.sin(AngleXYZ) * Distance + Z;
end

function GetAnglesBetweenPositions (X1, Y1, Z1, X2, Y2, Z2)
    return math.atan2(Y2 - Y1, X2 - X1) % (math.pi * 2), 
    math.atan((Z1 - Z2) / math.sqrt(math.pow(X1 - X2, 2) + math.pow(Y1 - Y2, 2))) % math.pi;
end

function GetPositionBetweenPositions (X1, Y1, Z1, X2, Y2, Z2, DistanceFromPosition1)
    local AngleXY, AngleXYZ = GetAnglesBetweenPositions(X1, Y1, Z1, X2, Y2, Z2);
    return GetPositionFromPosition(X1, Y1, Z1, DistanceFromPosition1, AngleXY, AngleXYZ);
end

--- Get whether an object is facing another.
-- Object1 (object)  - The first object
-- Object2 (object)  - The second object
-- returns (boolean) - Whether the first object is facing the second
-- Note: For custom angles, check UnitIsFacing API.
function ObjectIsFacing (Object1, Object2)

-- Returns whether an object is a quest object and the quest giver status.
-- Returns (boolean, status, tooltip1, tooltip2) - Whether it's a quest object, the quest giver status and the tooltip data
-- Note: The boolean and the tooltip returns only work on Shadowlands.
-- Status: 
-- Classic and BFA: 5 = Incomplete 8 = HasQuest   10 = CompletedQuest
-- Shadowlands:     5 = Incomplete 9 = DailyQuest 10 = HasQuest        12 = CompletedQuest
-- If you completed the requirements of a quest, then it will return false for the quest object/NPC.
function IsQuestObject(Object)

------------------------- Object Manager ------------------

--- Get the number of objects in the object manager and optionally 2 tables with all objects that were updated in the frame.
-- GetUpdates (boolean)  - True to get the tables with the objects that were updated in the frame.
-- Id (string)           - A simple string identifier to avoid conflicts between multiple addons calling GetObjectCount(true) in the same frame.
-- returns (integer, boolean, table, table) - The total number of objects, if the object manager was updated, the added objects and the removed objects.
-- Note: This should be the first API that you should call before using the other object manager functions.
-- Ideally, call it once every frame with an OnUpdate frame event.
-- You can use table.getn or # to get the number of objects in the returned tables.
-- Be careful with caching: the object manager can be updated after your GetObjectCount call within the same frame. 
function GetObjectCount ([GetUpdates, Id])
ObjectCount = GetObjectCount

--- Get an object in the object manager from its index.
-- Index   (integer) - The one-based index of the object. Starts at 1.
-- returns (object)  - The object
-- Note: If an object is at index 30, this does NOT mean that in the next frame it will be at index 30 again.
-- This API isn't really needed if you are properly using GetObjectCount(true).
function GetObjectWithIndex (Index)
ObjectWithIndex = GetObjectWithIndex

--- Get an object in the object manager from its GUID.
-- GUID    (string) - The GUID
-- returns (object) - The object or nil if it is not in the object manager
function GetObjectWithGUID (GUID)

------------------------- Unit ----------------------------

--- Get a unit's movement flags.
-- Unit    (unit)    - The unit
-- returns (integer) - The movement flags
function UnitMovementFlags (Unit)

--- Get a unit's bounding radius.
-- Unit    (unit)   - The unit
-- returns (number) - The bounding radius
function UnitBoundingRadius (Unit)

--- Get a unit's combat reach.
-- Unit    (unit)   - The unit
-- returns (number) - The combat reach
function UnitCombatReach (Unit)

--- Get a unit's target.
-- Unit    (unit) - The unit
-- returns (unit) - The target or nil if there is none
-- Note: This function reads a descriptor that is updated by the server. Don't use it to check if you have a target.
function UnitTarget (Unit)

--- Get an object's creator.
-- Object  (object) - The unit, game object or area trigger
-- returns (unit) - The creator or nil if there is none
function ObjectCreator (Unit)
UnitCreator = ObjectCreator

--- Get the spell IDs being casted or channelled by the unit
-- Unit    (unit)           - The unit
-- returns (number, number, object, object) - (Spell Cast ID, Spell Channel ID, Cast Object, Channel Object) 
-- Note1: If no spells are being casted, it returns 0, 0, nil, nil. On Classic, you only have the info about your player, not targets.
-- Note2: On certain WoW expansions, the Cast Object and Channel Object arent erased after cast. So you must always check if CastID and ChannelID arent 0.
-- Note3: On Classic, you may also look at the following libraries to provide spell info:
-- https://github.com/rgd87/LibClassicDurations
-- https://github.com/rgd87/LibClassicCasterino
function UnitCastID (Unit)

------------------------- World ---------------------------

--- Perform a raycast between two positions.
-- StartX  (number)                 - The starting X coordinate
-- StartY  (number)                 - The starting Y coordinate
-- StartZ  (number)                 - The starting Z coordinate
-- EndX    (number)                 - The ending X coordinate
-- EndY    (number)                 - The ending Y coordinate
-- EndZ    (number)                 - The ending Z coordinate
-- Flags   (integer)                - One or more members of the HitFlags table combined with bit.bor
-- returns (number, number, number, guid) - The XYZ coordinates of the hit position, the collision GUID, or nil if there was no hit. 
-- Be careful with how often you call this API because your FPS can drop a lot.
-- For generic LoS checks, use 0x100111 for Flags (M2, WMO, Terrain, Entity)
-- CActor's are M2 objects that have a GUID but they are not in the object manager. Their GUID are like "ClientActor-1-1-23"
function TraceLine (StartX, StartY, StartZ, EndX, EndY, EndZ [, Flags])

--- Get the camera position.
-- returns (number, number, number) - The XYZ coordinates of the camera
function GetCameraPosition ()

--- Cancel the pending spell if any.
function CancelPendingSpell ()

--- Simulate a click at a position in the game-world.
-- X     (number)  - The X coordinate
-- Y     (number)  - The Y coordinate
-- Z     (number)  - The Z coordinate
-- Right (boolean) - Whether to right click rather than left click
function ClickPosition (X, Y, Z[, Right])
CastAtPosition = ClickPosition

--- Get whether an AoE spell is pending a target.
-- returns (boolean) - Whether an AoE spell is pending a target
function IsAoEPending ()
    return SpellIsTargeting()
end

--- Get the screen coordinates relative from World coordinates
-- X        (number)  - The X coordinate.
-- Y        (number)  - The Y coordinate.
-- Z        (number)  - The Z coordinate.
-- returns  (number, number, boolean) - The X and Y screen coordinates for the XYZ coordinates and whether they are in front of the camera or not.
-- Note: Top-left (0, WorldFrame:GetTop())     Bottom-Right (WorldFrame:GetRight(), 0)
function WorldToScreen (X, Y, Z)

--- Get the World coordinates from screen coordinates
-- X        (number)  - The X coordinate.
-- Y        (number)  - The Y coordinate.
-- Flags    (number)  - One or more members of the HitFlags table combined with bit.bor
-- returns  (number, number, number) or nil if it failed - The XYZ world coordinates
-- Note: This API uses TraceLine internally so be careful with how often you call it so performance is not affected.
function ScreenToWorld (X, Y [, Flags] )

--- Return the mouse position relative to WoW's window and your screen/monitor
-- return (number, number, number, number) or nil if something failed - X and Y relative to WoW, X and Y relative to your screen/monitor
-- This API can be used with ScreenToWorld to get 3D world coordinates where the mouse is. 
function GetMousePosition()

------------------------- File ----------------------------

--- Get the names of the files in a directory.
-- Path    (string) - The path to the files
-- returns (table)  - The file names
-- Example: "C:\*" would retrieve the names of all of the files in C:\.
-- Example: "C:\*.dll" would retrieve the names of all of the .dll files in C:\.
function GetDirectoryFiles (Path)

--- Get the contents of a text file.
-- Path    (string) - The file path
-- Flags   (number) - Flags that control the behavior of ReadFile
-- 0x1 AsBinary - Whether the file contents should be returned as a table of bytes
-- 0x2 Execute  - Whether the file should be executed internally (mainly to avoid using RunString)
-- returns (string, table or number) - The file contents as string or table of bytes, or whether the file was executed correctly (1 = yes, 0 = no)
-- If the file doesn't exist, it returns nil.
-- Note: The table contains unsigned numbers, so {0x41, 0x42, 0x43, 0x85, 0xFE, -5, -10} will return {65, 66, 67, 133, 254, 251, 246}
function ReadFile (Path [, Flags])

--- Set the contents of or append a text file.
-- Path   (string)  - The file path
-- Contents (string or table)  - The file contents as a string or table of bytes
-- Append (boolean) - Whether to append rather than overwrite
-- CreatePath (boolean) - Whether to create directories for the given file path.
-- Note: If you provide just a filename in Path, then it will create the file where EWT is located.
function WriteFile (Path, Contents[, Append, CreatePath])

--- Creates a directory (folder) at the given path.
-- Path    (string) - The file path
-- returns (boolean) - True if the folder was created successfully or it already existed. False if it failed.
-- Note: If you pass a path like "D:\\myaddon\\rotations\\mage", 3 folders will be created.
function CreateDirectory (Path)

-- Whether a directory (folder) exists at the given path.
-- Returns (boolean)    - Whether it exists
function DirectoryExists(Path)

--- Get the directory that WoW is in.
-- returns (string) - The directory that WoW is in
function GetWoWDirectory ()

------------------------- Miscellaneous -------------------

--- Send an HTTP or HTTPS request.
-- URL        (string)   - The URL to send to
-- PostData   (string)   - The POST data if any (nil to use a GET request)
-- OnComplete (body, code, req, res, err) - The function to be called with the response if the request succeeds.
-- Headers    (string)   - Headers that should be added to the request. Split with \r\n.
-- Flags      (number)   - Flags that control the behavior of SendHTTPRequest. They can be combined.
-- 0x1 - Sync       - Whether SendHTTPRequest should be done synchronously or not
-- 0x2 - AsBinary   - Whether SendHTTPRequest should read the response (body) as binary (table of numbers)
-- 0x4 - RunLua     - Whether SendHTTPRequest should execute internally the downloaded Lua
-- Note1: This function doesn't return anything. Use the OnComplete callback for that.
-- Note2: If OnComplete is nil or you pass flag 4, SendHTTPRequest executes internally the Lua code returned from the HTTP request. 
-- Note3: Sync is mainly used if you need to do local requests that are fast. 
-- Note4: AsBinary can be combined with WriteFile to download files.
-- Note5: If you pass flag 4 and a callback, SendHTTPRequest returns (executed, code, nil, nil, err)
function SendHTTPRequest (URL, [ PostData, OnComplete, Headers, Flags] )

--- Get the state of a key.
-- Key     (integer)          - The virtual key code
-- returns (boolean, boolean) - Whether the key is down and whether the key is toggled
-- Virtual Key Codes: https://msdn.microsoft.com/en-us/library/windows/desktop/dd375731(v=vs.85).aspx
function GetKeyState (Key)