--+--------------------+--
--|Am I Fighting Helya?|--
--+--------------------+--
function isBadRotationsHelya()
  -- local objectCount = GetObjectCount() or 0
  for i = 1, ObjectCount() do
    local name = ObjectName(ObjectWithIndex(i))
    local object = ObjectWithIndex(i)
    if name == "Helya" and ObjectExists(object) then
      coverThatHole()
    else
      end
    end
  end