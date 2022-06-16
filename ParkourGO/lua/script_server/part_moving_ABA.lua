--CONFIGURATION AREA (KHU VỰC ĐIỀU CHỈNH)
local data = {
  --[[HƯỚNG DẪN SỬ DỤNG
  
  Mẫu: thispart = {dist=100,delay=0.01,dirtarget={start=Vector3.new(-0.1,0,0),ends=Vector3.new(0.1,0,0)}},
  Giải thích:
  thispart: Tên Part bạn muốn di chuyển trong map
  dist: Khoảng cách
    Lưu ý: Khoảng cách sẽ bị ảnh hưởng bởi Vector A/B
    Khoảng cách Part đi được = Khoảng cách x Vector A/B
      Ví dụ: trong trường hợp này Vector A của chúng ta là {x=-0.1,y=0,z=0}, khoảng cách của chúng ta là 100 thì Khoảng cách x Vector A = 100 x -0.01
        => Part thispart của chúng ta di chuyển được 1 tọa độ hướng về -x
  delay: Khoảng thời gian delay giữa mỗi lần di chuyển (càng thấp càng mượt, thấp nhất: 0.01)
  dirtarget: Kho chứa Vector A và B
    start: Vector A
    end: Vector B
  
  BẠN CÓ THỂ VIẾT NGAY SAU DÒNG NÀY]]
  cyclinder1 = {dist=50,delay=0.01,dirtarget={start=Vector3.new(0,0,-0.1),ends=Vector3.new(0,0,0.1)}},
  cyclinder2 = {dist=50,delay=0.01,dirtarget={start=Vector3.new(0,0,0.1),ends=Vector3.new(0,0,-0.1)}},
  cyclinder3 = {dist=65,delay=0.01,dirtarget={start=Vector3.new(0,0,-0.1),ends=Vector3.new(0,0,0.1)}},
  cyclinder4 = {dist=60,delay=0.01,dirtarget={start=Vector3.new(0,0,0.1),ends=Vector3.new(0,0,-0.1)}},
  cyclinder5 = {dist=50,delay=0.01,dirtarget={start=Vector3.new(0,0,-0.1),ends=Vector3.new(0,0,0.1)}},
  cyclinder6 = {dist=50,delay=0.01,dirtarget={start=Vector3.new(0,0,0.1),ends=Vector3.new(0,0,-0.1)}},
  cyclinder7 = {dist=50,delay=0.01,dirtarget={start=Vector3.new(0,0,-0.1),ends=Vector3.new(0,0,0.1)}},
  cyclinder8 = {dist=50,delay=0.01,dirtarget={start=Vector3.new(0,0,0.1),ends=Vector3.new(0,0,-0.1)}},
  cyclinder9 = {dist=50,delay=0.01,dirtarget={start=Vector3.new(0,0,-0.1),ends=Vector3.new(0,0,0.1)}},
  cyclinder10 = {dist=50,delay=0.01,dirtarget={start=Vector3.new(0,0,0.1),ends=Vector3.new(0,0,-0.1)}},
  updown1 = {dist=50,delay=0.01,dirtarget={start=Vector3.new(0,0.1,0),ends=Vector3.new(0,-0.1,0)}},
  updown2 = {dist=50,delay=0.01,dirtarget={start=Vector3.new(0,-0.1,0),ends=Vector3.new(0,0.1,0)}},
  side1 = {dist=35,delay=0.01,dirtarget={start=Vector3.new(-0.1,0,0),ends=Vector3.new(0.1,0,0)}},
  side2 = {dist=35,delay=0.01,dirtarget={start=Vector3.new(0.1,0,0),ends=Vector3.new(-0.1,0,0)}},
  cyclinder11 = {dist=150,delay=0.01,dirtarget={start=Vector3.new(-0.1,0,0),ends=Vector3.new(0.1,0,0)}},
  cyclinder12 = {dist=175,delay=0.01,dirtarget={start=Vector3.new(-0.1,0,0),ends=Vector3.new(0.1,0,0)}},
  cyclinder13 = {dist=25,delay=0.01,dirtarget={start=Vector3.new(-0.1,0,0),ends=Vector3.new(0.1,0,0)}},
  cyclinder14 = {dist=50,delay=0.01,dirtarget={start=Vector3.new(-0.1,0,0),ends=Vector3.new(0.1,0,0)}},
  cyclinder15 = {dist=150,delay=0.01,dirtarget={start=Vector3.new(-0.1,0,0),ends=Vector3.new(0.1,0,0)}},
  cyclinder16 = {dist=75,delay=0.01,dirtarget={start=Vector3.new(-0.1,0,0),ends=Vector3.new(0.1,0,0)}},
  cyclinder17 = {dist=175,delay=0.01,dirtarget={start=Vector3.new(-0.1,0,0),ends=Vector3.new(0.1,0,0)}},
  cyclinder18 = {dist=150,delay=0.01,dirtarget={start=Vector3.new(-0.1,0,0),ends=Vector3.new(0.1,0,0)}},
  cyclinder19 = {dist=25,delay=0.01,dirtarget={start=Vector3.new(-0.1,0,0),ends=Vector3.new(0.1,0,0)}},
  cyclinder20 = {dist=5,delay=0.01,dirtarget={start=Vector3.new(-0.1,0,0),ends=Vector3.new(0.1,0,0)}},
  cyclinder21 = {dist=150,delay=0.01,dirtarget={start=Vector3.new(-0.1,0,0),ends=Vector3.new(0.1,0,0)}},
  cyclinder22 = {dist=50,delay=0.01,dirtarget={start=Vector3.new(-0.1,0,0),ends=Vector3.new(0.1,0,0)}},
}

local starterID = "starter" --starterID: ID của Entity dùng làm vật bắt đầu

--SCRIPT AREA (KHÔNG ĐIỀU CHỈNH NẾU KHÔNG HIỂU BIẾT VỀ LUA SCRIPT!)
local starterCfg = Entity.GetCfg("myplugin/"..starterID)
Trigger.RegisterHandler(starterCfg,"ENTITY_TOUCH_PART_BEGIN",function(context)
    context.obj1:kill()
    
    print("TOUCHED TOUCHED TOUCHED.")
    print(context.part.name)
    
    local part = context.part
    
    local name = part.name
    if data[name] ~= nil then
      local dist = data[name].dist
      local delay = data[name].delay
      local startdir = data[name].dirtarget.start
      local enddir = data[name].dirtarget.ends
      local counter = 0
      local targetdir = startdir
      World.Timer(20*delay,function()
          if counter == dist then
            counter = 0
            if targetdir == startdir then
              targetdir = enddir
            else
              targetdir=startdir
            end
          end
          
          part:move(targetdir)
          counter = counter + 1
          
          return true
      end)
    end
end)