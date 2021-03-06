components {
  id: "trail_maker"
  component: "/hyper_trails/trail_maker.script"
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
  properties {
    id: "use_world_position"
    value: "true"
    type: PROPERTY_TYPE_BOOLEAN
  }
  properties {
    id: "trail_width"
    value: "80.0"
    type: PROPERTY_TYPE_NUMBER
  }
  properties {
    id: "points_count"
    value: "64.0"
    type: PROPERTY_TYPE_NUMBER
  }
  properties {
    id: "shrink_tail_width"
    value: "true"
    type: PROPERTY_TYPE_BOOLEAN
  }
}
embedded_components {
  id: "trail_model"
  type: "model"
  data: "mesh: \"/hyper_trails/models/trail_64.dae\"\n"
  "material: \"/assets/materials/trail/trail.material\"\n"
  "textures: \"/hyper_trails/textures/data/texture0_1.png\"\n"
  "textures: \"/assets/imgs/trail.png\"\n"
  "skeleton: \"\"\n"
  "animations: \"\"\n"
  "default_animation: \"\"\n"
  "name: \"unnamed\"\n"
  ""
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
