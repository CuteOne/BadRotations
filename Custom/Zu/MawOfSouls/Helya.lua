--+--------------------+--
--|Am I Fighting Helya?|--
--+--------------------+--
function isBadRotationsHelya()
  local objectCount = GetObjectCount() or ObjectCount() or 0
  for i = 1, objectCount do
    local name = ObjectName(ObjectWithIndex(i))
    local object = ObjectWithIndex(i)
    if name == "Helya" and ObjectExists(object) then
      coverThatHole()
    else
      end
    end
  end