local ecs = require("libs.evolved")

return {
	update = ecs.builder():name("groups.update"):build(),
	draw = ecs.builder():name("groups.draw"):build(),
}
