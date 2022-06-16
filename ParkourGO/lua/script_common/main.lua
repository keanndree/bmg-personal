print('script_common:hello world')
Entity.addValueDef("time", -1, true, true, true)
Entity.addValueDef("SecondJump",{valid=false,avail=false},false,false,true)
Entity.addValueDef("ItemAttribute",{
    speed={level=1,maxlevel=5,expnow=0,expneed=50},
    spring={level=1,maxlevel=5,expnow=0,expneed=50},
    goldenspring={level=1,maxlevel=5,expnow=0,expneed=50},
    shield={level=1,maxlevel=5,expnow=0,expneed=50},
    sniper={level=1,maxlevel=5,expnow=0,expneed=50}
    },false,false,true)
Entity.addValueDef("Money",0,false,false,true)
Entity.addValueDef("LevelProgress",{level=1,maxlevel=100,expnow=0,expneed=50},false,false,true)