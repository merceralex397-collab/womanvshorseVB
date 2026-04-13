extends Node

# Creates a GPUParticles2D with the given parameters
func create_particles(
    p_amount: int,
    p_lifetime: float,
    p_explosiveness: float,
    p_color: Color,
    p_direction: Vector3,
    p_spread: float,
    p_initial_velocity_min: float,
    p_initial_velocity_max: float,
    p_scale_min: float,
    p_scale_max: float,
    p_gravity_min: float = 0.0,
    p_gravity_max: float = 0.0
) -> GPUParticles2D:
    var particles = GPUParticles2D.new()
    particles.amount = p_amount
    particles.lifetime = p_lifetime
    particles.explosiveness = p_explosiveness
    particles.one_shot = true
    
    var mat = ParticleProcessMaterial.new()
    mat.direction = p_direction
    mat.spread = p_spread
    mat.initial_velocity_min = p_initial_velocity_min
    mat.initial_velocity_max = p_initial_velocity_max
    mat.scale_min = p_scale_min
    mat.scale_max = p_scale_max
    mat.color = p_color
    mat.gravity_min = p_gravity_min
    mat.gravity_max = p_gravity_max
    particles.process_material = mat
    
    return particles

# Spawns particles and auto-cleanups when finished
func spawn_particles(
    parent: Node,
    world_position: Vector2,
    p_amount: int,
    p_lifetime: float,
    p_explosiveness: float,
    p_color: Color,
    p_direction: Vector3 = Vector3(0, -1, 0),
    p_spread: float = 180.0,
    p_initial_velocity_min: float = 100.0,
    p_initial_velocity_max: float = 200.0,
    p_scale_min: float = 3.0,
    p_scale_max: float = 6.0,
    p_gravity_min: float = 200.0,
    p_gravity_max: float = 400.0
) -> GPUParticles2D:
    var particles = create_particles(
        p_amount, p_lifetime, p_explosiveness, p_color,
        p_direction, p_spread, p_initial_velocity_min, p_initial_velocity_max,
        p_scale_min, p_scale_max, p_gravity_min, p_gravity_max
    )
    particles.position = world_position
    parent.add_child(particles)
    particles.finished.connect(func(): 
        if particles and is_instance_valid(particles):
            particles.queue_free()
    )
    return particles
