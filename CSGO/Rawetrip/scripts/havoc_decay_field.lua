--region dependencies
--region std_api
--region math
--- Round a number to the nearest precision, or none by default.
--- @param number number
--- @param precision number
--- @return number
function math.round(number, precision)
	local mult = 10 ^ (precision or 0)

	return math.floor(number * mult + 0.5) / mult
end

--- @info: none
function math.random_float(min, max)
    return math.random() * (max - min) + min
end

--- @info: none
function math.pow(a, b)
	return a ^ b
end

--- @info: none
function math.atan2(...)
	return math.atan(...)
end
--endregion

--region custom callback
local callbacks = {}
local data_call = {}

callbacks.setup = function(callback)
    assert(type(callback) == "string", "[debugger] Invalid type of callback")

    callbacks[callback] = {}
    callbacks[callback].list = {}

    callbacks[callback].func = function(...)
        for i, j in pairs(callbacks[callback].list) do
            j(...)
        end
    end

    cheat.RegisterCallback(callback, callbacks[callback].func)
end

callbacks.push = function(callback, func)
    assert(func, "[debugger] Undefined callbacked variable")
    assert(type(func) == "function", "[debugger] Invalid type of callbacked variable")

    if not callbacks[callback] then
        callbacks.setup(callback)
    end

    table.insert(callbacks[callback].list, func)
end

callbacks.push_event = function(callback, func)
    assert(func, "[debugger] Undefined callbacked variable")
    assert(type(func) == "function", "[debugger] Invalid type of callbacked variable")

    events.register_event(callback, function(e) func(e) end)
end

callbacks.pop = function(callback, func)
    assert(callbacks[callback], "[debugger] Undefined callback")
    assert(type(func) == "function", "[debugger] Invalid type of variable to pop")

    for k, v in pairs(callbacks[callback].list) do
        if v == func then
            table.remove(callbacks[callback].list, k)

            return
        end
    end
end

callbacks.push_delay = function(time, fn)
    table.insert(data_call, {
        fn = fn,
        time = time,
        realtime = globalvars.get_realtime()
    })

    callbacks.push("on_paint", function()
        for key, data in ipairs(data_call) do
            if data.realtime + data.time < globalvars.get_realtime() then
                data.fn()
                data.realtime = globalvars.get_realtime()
            end
        end
    end)
end
--endregion

--region sense api
--- @info: globals
local globals = {}

globals.realtime = globalvars.get_realtime
globals.tickcount = globalvars.get_tickcount
globals.frametime = globalvars.get_frametime
globals.absoluteframetime = globalvars.get_frametime
--endregion

--region table
--- Returns true if the table contains the value being searched for.
--- @param search_table table
--- @param search_value any
--- @return boolean
function table.contains(search_table, search_value)
	for _, table_value in pairs(search_table) do
		if (search_value == table_value) then
			return true
		end
	end

	return false
end
--endregion
--endregion

--region hvc_api
--- Sorted pairs iteration.
--- @param t table<any, any>
--- @param order function
--- @return table<any, any>
local function spairs(t, order)
	-- Collect the keys
	local keys = {}

	for k in pairs(t) do keys[#keys+1] = k end
	-- If order function given, sort by it by passing the table and keys a, b,
	-- otherwise just sort the keys
	if order then
		table.sort(keys, function(a,b) return order(t, a, b) end)
	else
		table.sort(keys)
	end

	local i = 0

	-- Return the iterator function.
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end
--endregion

--region dependency: havoc_panic_1_0_1
--- Acts as a fail-safe that trips a script into shutting down safely, and resetting players to use the Gamesense resolver.
--- @class panic_c
local panic_c = {}
local panic_mt = { __index = panic_c }

--- Instaniate panic_c.
--- @return panic_c
function panic_c.new(panic_callback)
	return setmetatable(
		{
			interrupt = false, -- Was the previous cycle interrupted?
			panic = false, -- Has the system entered panic mode?
			panic_callback = panic_callback, -- Callback to run upon a panic.
		},
		panic_mt
	)
end

--- Test to ensure that all running processes from the previous cycle were successful and did not encounter errors.
--- @vararg any
function panic_c:test(...)
	if (self.interrupt == true and self.panic == false) then
		-- Panic if the interrupt was never reset from the previous cycle.
		self.panic = true
	elseif (self.interrupt == true and self.panic == true) then
		-- Otherwise, if the previous cycle already initiated the panic, no further action is required.
		-- Let the execuding code know that the test failed.
		return false
	end

	-- Initiate the panic.
	if (self.interrupt == true) then
		self.panic = true

		-- Run the panic callback given to us.
		self.panic_callback(...)
	end

	-- Let the executing code know that the test passed.
	return true
end

--- Begin the panic test.
--- Run this at the start of events.
--- @return void
function panic_c:start()
	self.interrupt = true
end

--- End the panic test.
--- Run this at the end of events.
--- @return void
function panic_c:stop()
	self.interrupt = false
end

--- Forcefully trigger a panic attack.
--- Call this mid-test.
--- @return void
function panic_c:trip()
	self.interrupt = true
end
--endregion

--region dependency: havoc_vector_2_2_0
--region math
function math.round(number, precision)
	local mult = 10 ^ (precision or 0)

	return math.floor(number * mult + 0.5) / mult
end
--endregion

--region angle
--- @class angle_old_c
--- @field public p number Angle pitch.
--- @field public y number Angle yaw.
--- @field public r number Angle roll.
local angle_old_c = {}
local angle_mt = {
	__index = angle_old_c
}

--- Overwrite the angle's angles. Nil values leave the angle unchanged.
--- @param angle angle_old_c
--- @param p_new number
--- @param y_new number
--- @param r_new number
--- @return void
angle_mt.__call = function(angle, p_new, y_new, r_new)
	p_new = p_new or angle.p
	y_new = y_new or angle.y
	r_new = r_new or angle.r

	angle.p = p_new
	angle.y = y_new
	angle.r = r_new
end

--- Create a new vector object.
--- @param p number
--- @param y number
--- @param r number
--- @return angle_old_c
local function angle(p, y, r)
	return setmetatable(
		{
			p = p and p or 0,
			y = y and y or 0,
			r = r and r or 0
		},
		angle_mt
	)
end

--- Offset the angle's angles. Nil values leave the angle unchanged.
--- @param p_offset number
--- @param y_offset number
--- @param r_offset number
--- @return void
function angle_old_c:offset(p_offset, y_offset, r_offset)
	p_offset = self.p + p_offset or 0
	y_offset = self.y + y_offset or 0
	r_offset = self.r + r_offset or 0

	self.p = self.p + p_offset
	self.y = self.y + y_offset
	self.r = self.r + r_offset
end

--- Clone the angle object.
--- @return angle_old_c
function angle_old_c:clone()
	return setmetatable(
		{
			p = self.p,
			y = self.y,
			r = self.r
		},
		angle_mt
	)
end

--- Clone and offset the angle's angles. Nil values leave the angle unchanged.
--- @param p_offset number
--- @param y_offset number
--- @param r_offset number
--- @return angle_old_c
function angle_old_c:clone_offset(p_offset, y_offset, r_offset)
	p_offset = self.p + p_offset or 0
	y_offset = self.y + y_offset or 0
	r_offset = self.r + r_offset or 0

	return angle(
		self.p + p_offset,
		self.y + y_offset,
		self.r + r_offset
	)
end

--- Unpack the angle.
--- @return number, number, number
function angle_old_c:unpack()
	return self.p, self.y, self.r
end

--- Set the angle's euler angles to 0.
--- @return void
function angle_old_c:nullify()
	self.p = 0
	self.y = 0
	self.r = 0
end

--- Returns a string representation of the angle.
function angle_mt.__tostring(operand_a)
	return string.format("%s, %s, %s", operand_a.p, operand_a.y, operand_a.r)
end

--- Concatenates the angle in a string.
function angle_mt.__concat(operand_a)
	return string.format("%s, %s, %s", operand_a.p, operand_a.y, operand_a.r)
end

--- Adds the angle to another angle.
function angle_mt.__add(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a + operand_b.p,
			operand_a + operand_b.y,
			operand_a + operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p + operand_b,
			operand_a.y + operand_b,
			operand_a.r + operand_b
		)
	end

	return angle(
		operand_a.p + operand_b.p,
		operand_a.y + operand_b.y,
		operand_a.r + operand_b.r
	)
end

--- Subtracts the angle from another angle.
function angle_mt.__sub(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a - operand_b.p,
			operand_a - operand_b.y,
			operand_a - operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p - operand_b,
			operand_a.y - operand_b,
			operand_a.r - operand_b
		)
	end

	return angle(
		operand_a.p - operand_b.p,
		operand_a.y - operand_b.y,
		operand_a.r - operand_b.r
	)
end

--- Multiplies the angle with another angle.
function angle_mt.__mul(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a * operand_b.p,
			operand_a * operand_b.y,
			operand_a * operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p * operand_b,
			operand_a.y * operand_b,
			operand_a.r * operand_b
		)
	end

	return angle(
		operand_a.p * operand_b.p,
		operand_a.y * operand_b.y,
		operand_a.r * operand_b.r
	)
end

--- Divides the angle by the another angle.
function angle_mt.__div(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a / operand_b.p,
			operand_a / operand_b.y,
			operand_a / operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p / operand_b,
			operand_a.y / operand_b,
			operand_a.r / operand_b
		)
	end

	return angle(
		operand_a.p / operand_b.p,
		operand_a.y / operand_b.y,
		operand_a.r / operand_b.r
	)
end

--- Raises the angle to the power of an another angle.
function angle_mt.__pow(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			math.pow(operand_a, operand_b.p),
			math.pow(operand_a, operand_b.y),
			math.pow(operand_a, operand_b.r)
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			math.pow(operand_a.p, operand_b),
			math.pow(operand_a.y, operand_b),
			math.pow(operand_a.r, operand_b)
		)
	end

	return angle(
		math.pow(operand_a.p, operand_b.p),
		math.pow(operand_a.y, operand_b.y),
		math.pow(operand_a.r, operand_b.r)
	)
end

--- Performs modulo on the angle with another angle.
function angle_mt.__mod(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a % operand_b.p,
			operand_a % operand_b.y,
			operand_a % operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p % operand_b,
			operand_a.y % operand_b,
			operand_a.r % operand_b
		)
	end

	return angle(
		operand_a.p % operand_b.p,
		operand_a.y % operand_b.y,
		operand_a.r % operand_b.r
	)
end

--- Perform a unary minus operation on the angle.
function angle_mt.__unm(operand_a)
	return angle(
		-operand_a.p,
		-operand_a.y,
		-operand_a.r
	)
end

--- Clamps the angle's angles to whole numbers. Equivalent to "angle:round" with no precision.
--- @return void
function angle_old_c:round_zero()
	self.p = math.floor(self.p + 0.5)
	self.y = math.floor(self.y + 0.5)
	self.r = math.floor(self.r + 0.5)
end

--- Round the angle's angles.
--- @param precision number
function angle_old_c:round(precision)
	self.p = math.round(self.p, precision)
	self.y = math.round(self.y, precision)
	self.r = math.round(self.r, precision)
end

--- Clamps the angle's angles to the nearest base.
--- @param base number
function angle_old_c:round_base(base)
	self.p = base * math.round(self.p / base)
	self.y = base * math.round(self.y / base)
	self.r = base * math.round(self.r / base)
end

--- Clamps the angle's angles to whole numbers. Equivalent to "angle:round" with no precision.
--- @return angle_old_c
function angle_old_c:rounded_zero()
	return angle(
		math.floor(self.p + 0.5),
		math.floor(self.y + 0.5),
		math.floor(self.r + 0.5)
	)
end

--- Round the angle's angles.
--- @param precision number
--- @return angle_old_c
function angle_old_c:rounded(precision)
	return angle(
		math.round(self.p, precision),
		math.round(self.y, precision),
		math.round(self.r, precision)
	)
end

--- Clamps the angle's angles to the nearest base.
--- @param base number
--- @return angle_old_c
function angle_old_c:rounded_base(base)
	return angle(
		base * math.round(self.p / base),
		base * math.round(self.y / base),
		base * math.round(self.r / base)
	)
end
--endregion

--region vector
--- @class vector_old_c
--- @field public x number X coordinate.
--- @field public y number Y coordinate.
--- @field public z number Z coordinate.
local vector_old_c = {}
local vector_mt = {
	__index = vector_old_c,
}

--- Overwrite the vector's coordinates. Nil will leave coordinates unchanged.
--- @param x_new number
--- @param y_new number
--- @param z_new number
--- @return void
vector_mt.__call = function(vector, x_new, y_new, z_new)
	x_new = x_new or vector.x
	y_new = y_new or vector.y
	z_new = z_new or vector.z

	vector.x = x_new
	vector.y = y_new
	vector.z = z_new
end

--- Create a new vector object.
--- @param x number
--- @param y number
--- @param z number
--- @return vector_old_c
local function vectorh(x, y, z)
	return setmetatable(
		{
			x = x and x or 0,
			y = y and y or 0,
			z = z and z or 0
		},
		vector_mt
	)
end

--- Offset the vector's coordinates. Nil will leave the coordinates unchanged.
--- @param x_offset number
--- @param y_offset number
--- @param z_offset number
--- @return void
function vector_old_c:offset(x_offset, y_offset, z_offset)
	x_offset = x_offset or 0
	y_offset = y_offset or 0
	z_offset = z_offset or 0

	self.x = self.x + x_offset
	self.y = self.y + y_offset
	self.z = self.z + z_offset
end

--- Clone the vector object.
--- @return vector_old_c
function vector_old_c:clone()
	return setmetatable(
		{
			x = self.x,
			y = self.y,
			z = self.z
		},
		vector_mt
	)
end

--- Clone the vector object and offset its coordinates. Nil will leave the coordinates unchanged.
--- @param x_offset number
--- @param y_offset number
--- @param z_offset number
--- @return vector_old_c
function vector_old_c:clone_offset(x_offset, y_offset, z_offset)
	x_offset = x_offset or 0
	y_offset = y_offset or 0
	z_offset = z_offset or 0

	return setmetatable(
		{
			x = self.x + x_offset,
			y = self.y + y_offset,
			z = self.z + z_offset
		},
		vector_mt
	)
end

--- Unpack the vector.
--- @return number, number, number
function vector_old_c:unpack()
	return self.x, self.y, self.z
end

--- Set the vector's coordinates to 0.
--- @return void
function vector_old_c:nullify()
	self.x = 0
	self.y = 0
	self.z = 0
end

--- Returns a string representation of the vector.
function vector_mt.__tostring(operand_a)
	return string.format("%s, %s, %s", operand_a.x, operand_a.y, operand_a.z)
end

--- Concatenates the vector in a string.
function vector_mt.__concat(operand_a)
	return string.format("%s, %s, %s", operand_a.x, operand_a.y, operand_a.z)
end

--- Returns true if the vector's coordinates are equal to another vector.
function vector_mt.__eq(operand_a, operand_b)
	return (operand_a.x == operand_b.x) and (operand_a.y == operand_b.y) and (operand_a.z == operand_b.z)
end

--- Returns true if the vector is less than another vector.
function vector_mt.__lt(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return (operand_a < operand_b.x) or (operand_a < operand_b.y) or (operand_a < operand_b.z)
	end

	if (type(operand_b) == "number") then
		return (operand_a.x < operand_b) or (operand_a.y < operand_b) or (operand_a.z < operand_b)
	end

	return (operand_a.x < operand_b.x) or (operand_a.y < operand_b.y) or (operand_a.z < operand_b.z)
end

--- Returns true if the vector is less than or equal to another vector.
function vector_mt.__le(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return (operand_a <= operand_b.x) or (operand_a <= operand_b.y) or (operand_a <= operand_b.z)
	end

	if (type(operand_b) == "number") then
		return (operand_a.x <= operand_b) or (operand_a.y <= operand_b) or (operand_a.z <= operand_b)
	end

	return (operand_a.x <= operand_b.x) or (operand_a.y <= operand_b.y) or (operand_a.z <= operand_b.z)
end

--- Add a vector to another vector.
function vector_mt.__add(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vectorh(
			operand_a + operand_b.x,
			operand_a + operand_b.y,
			operand_a + operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vectorh(
			operand_a.x + operand_b,
			operand_a.y + operand_b,
			operand_a.z + operand_b
		)
	end

	return vectorh(
		operand_a.x + operand_b.x,
		operand_a.y + operand_b.y,
		operand_a.z + operand_b.z
	)
end

--- Subtract a vector from another vector.
function vector_mt.__sub(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vectorh(
			operand_a - operand_b.x,
			operand_a - operand_b.y,
			operand_a - operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vectorh(
			operand_a.x - operand_b,
			operand_a.y - operand_b,
			operand_a.z - operand_b
		)
	end

	return vectorh(
		operand_a.x - operand_b.x,
		operand_a.y - operand_b.y,
		operand_a.z - operand_b.z
	)
end

--- Multiply a vector with another vector.
function vector_mt.__mul(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vectorh(
			operand_a * operand_b.x,
			operand_a * operand_b.y,
			operand_a * operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vectorh(
			operand_a.x * operand_b,
			operand_a.y * operand_b,
			operand_a.z * operand_b
		)
	end

	return vectorh(
		operand_a.x * operand_b.x,
		operand_a.y * operand_b.y,
		operand_a.z * operand_b.z
	)
end

--- Divide a vector by another vector.
function vector_mt.__div(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vectorh(
			operand_a / operand_b.x,
			operand_a / operand_b.y,
			operand_a / operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vectorh(
			operand_a.x / operand_b,
			operand_a.y / operand_b,
			operand_a.z / operand_b
		)
	end

	return vectorh(
		operand_a.x / operand_b.x,
		operand_a.y / operand_b.y,
		operand_a.z / operand_b.z
	)
end

--- Raised a vector to the power of another vector.
function vector_mt.__pow(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vectorh(
			math.pow(operand_a, operand_b.x),
			math.pow(operand_a, operand_b.y),
			math.pow(operand_a, operand_b.z)
		)
	end

	if (type(operand_b) == "number") then
		return vectorh(
			math.pow(operand_a.x, operand_b),
			math.pow(operand_a.y, operand_b),
			math.pow(operand_a.z, operand_b)
		)
	end

	return vectorh(
		math.pow(operand_a.x, operand_b.x),
		math.pow(operand_a.y, operand_b.y),
		math.pow(operand_a.z, operand_b.z)
	)
end

--- Performs a modulo operation on a vector with another vector.
function vector_mt.__mod(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vectorh(
			operand_a % operand_b.x,
			operand_a % operand_b.y,
			operand_a % operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vectorh(
			operand_a.x % operand_b,
			operand_a.y % operand_b,
			operand_a.z % operand_b
		)
	end

	return vectorh(
		operand_a.x % operand_b.x,
		operand_a.y % operand_b.y,
		operand_a.z % operand_b.z
	)
end

--- Perform a unary minus operation on the vector.
function vector_mt.__unm(operand_a)
	return vectorh(
		-operand_a.x,
		-operand_a.y,
		-operand_a.z
	)
end

--- Returns the vector's 2 dimensional length squared.
--- @return number
function vector_old_c:length2_squared()
	return (self.x * self.x) + (self.y * self.y);
end

--- Return's the vector's 2 dimensional length.
--- @return number
function vector_old_c:length2()
	return math.sqrt(self:length2_squared())
end

--- Returns the vector's 3 dimensional length squared.
--- @return number
function vector_old_c:length_squared()
	return (self.x * self.x) + (self.y * self.y) + (self.z * self.z);
end

--- Return's the vector's 3 dimensional length.
--- @return number
function vector_old_c:length()
	return math.sqrt(self:length_squared())
end

--- Returns the vector's dot product.
--- @param other_vector vector_old_c
--- @return number
function vector_old_c:dot_product(other_vector)
	return (self.x * other_vector.x) + (self.y * other_vector.y) + (self.z * other_vector.z)
end

--- Returns the vector's cross product.
--- @param other_vector vector_old_c
--- @return vector_old_c
function vector_old_c:cross_product(other_vector)
	return vector_old_c(
		(self.y * other_vector.z) - (self.z * other_vector.y),
		(self.z * other_vector.x) - (self.x * other_vector.z),
		(self.x * other_vector.y) - (self.y * other_vector.x)
	)
end

--- Returns the 2 dimensional distance between the vector and another vector.
--- @param other_vector vector_old_c
--- @return number
function vector_old_c:distance2(other_vector)
	return (other_vector - self):length2()
end

--- Returns the 3 dimensional distance between the vector and another vector.
--- @param other_vector vector_old_c
--- @return number
function vector_old_c:distance(other_vector)
	return (other_vector - self):length()
end

--- Returns the distance on the X axis between the vector and another vector.
--- @param other_vector vector_old_c
--- @return number
function vector_old_c:distance_x(other_vector)
	return math.abs(self.x - other_vector.x)
end

--- Returns the distance on the Y axis between the vector and another vector.
--- @param other_vector vector_old_c
--- @return number
function vector_old_c:distance_y(other_vector)
	return math.abs(self.y - other_vector.y)
end

--- Returns the distance on the Z axis between the vector and another vector.
--- @param other_vector vector_old_c
--- @return number
function vector_old_c:distance_z(other_vector)
	return math.abs(self.z - other_vector.z)
end

--- Returns true if the vector is within the given distance to another vector.
--- @param other_vector vector_old_c
--- @param distance number
--- @return boolean
function vector_old_c:in_range(other_vector, distance)
	return self:distance(other_vector) <= distance
end

--- Clamps the vector's coordinates to whole numbers. Equivalent to "vector:round" with no precision.
--- @return void
function vector_old_c:round_zero()
	self.x = math.floor(self.x + 0.5)
	self.y = math.floor(self.y + 0.5)
	self.z = math.floor(self.z + 0.5)
end

--- Round the vector's coordinates.
--- @param precision number
--- @return void
function vector_old_c:round(precision)
	self.x = math.round(self.x, precision)
	self.y = math.round(self.y, precision)
	self.z = math.round(self.z, precision)
end

--- Clamps the vector's coordinates to the nearest base.
--- @param base number
--- @return void
function vector_old_c:round_base(base)
	self.x = base * math.round(self.x / base)
	self.y = base * math.round(self.y / base)
	self.z = base * math.round(self.z / base)
end

--- Clamps the vector's coordinates to whole numbers. Equivalent to "vector:round" with no precision.
--- @return vector_old_c
function vector_old_c:rounded_zero()
	return vectorh(
		math.floor(self.x + 0.5),
		math.floor(self.y + 0.5),
		math.floor(self.z + 0.5)
	)
end

--- Round the vector's coordinates.
--- @param precision number
--- @return vector_old_c
function vector_old_c:rounded(precision)
	return vectorh(
		math.round(self.x, precision),
		math.round(self.y, precision),
		math.round(self.z, precision)
	)
end

--- Clamps the vector's coordinates to the nearest base.
--- @param base number
--- @return vector_old_c
function vector_old_c:rounded_base(base)
	return vectorh(
		base * math.round(self.x / base),
		base * math.round(self.y / base),
		base * math.round(self.z / base)
	)
end

--- Normalize the vector.
--- @return void
function vector_old_c:normalize()
	local length = self:length()

	-- Prevent possible divide-by-zero errors.
	if (length ~= 0) then
		self.x = self.x / length
		self.y = self.y / length
		self.z = self.z / length
	else
		self.x = 0
		self.y = 0
		self.z = 1
	end
end

--- Returns the normalized length of a vector.
--- @return number
function vector_old_c:normalized_length()
	return self:length()
end

--- Returns a copy of the vector, normalized.
--- @return vector_old_c
function vector_old_c:normalized()
	local length = self:length()

	if (length ~= 0) then
		return vectorh(
			self.x / length,
			self.y / length,
			self.z / length
		)
	else
		return vectorh(0, 0, 1)
	end
end

--- Returns a new 2 dimensional vector of the original vector when mapped to the screen, or nil if the vector is off-screen.
--- @return vector_old_c
function vector_old_c:to_screen()
	local screen = render.world_to_screen(vector.new(self.x, self.y, self.z))

	if (screen.x == nil or screen.y == nil) then
		return nil
	end

	return vectorh(screen.x, screen.y)
end

--- Returns the magnitude of the vector, use this to determine the speed of the vector if it's a velocity vector.
--- @return number
function vector_old_c:magnitude()
	return math.sqrt(
		math.pow(self.x, 2) +
			math.pow(self.y, 2) +
			math.pow(self.z, 2)
	)
end

--- Returns the angle of the vector in regards to another vector.
--- @param destination vector_old_c
--- @return angle_old_c
function vector_old_c:angle_to(destination)
	-- Calculate the delta of vectors.
	local delta_vector = vectorh(destination.x - self.x, destination.y - self.y, destination.z - self.z)

	if (delta_vector.x == 0 and delta_vector.y == 0) then
		return angle((delta_vector.z > 0 and 270 or 90), 0)
	else
		-- Calculate the yaw.
		local yaw = math.deg(math.atan2(delta_vector.y, delta_vector.x))

		-- Calculate the pitch.
		local hyp = math.sqrt(delta_vector.x * delta_vector.x + delta_vector.y * delta_vector.y)
		local pitch = math.deg(math.atan2(-delta_vector.z, hyp))

		return angle(pitch, yaw)
	end
end

--- Returns the result of client.trace_line between two vectors.
--- @param destination vector_old_c
--- @param skip_entindex number
--- @return number, number|nil
function vector_old_c:trace_line_to(destination, skip_entindex, mask)
	skip_entindex = skip_entindex == nil and entitylist.get_local_player() or skip_entindex
	mask = mask == nil and 0x201400B or mask

	return trace.ray(vector.new(self.x, self.y, self.z), vector.new(destination.x, destination.y, destination.z), skip_entindex, mask).fraction
end

--- Lerp to another vector.
--- @param target vector_old_c
--- @param percentage number
--- @return vector_old_c
function vector_old_c:lerp(target, percentage)
	return self + (target - self) * percentage
end

--- Returns the vector of the closest point along a ray.
--- @param source vector_old_c
--- @param destination vector_old_c
--- @return vector_old_c
function vector_old_c:closest_ray_point(source, destination)
	local direction = (destination - source) / source:distance(destination)
	local v = self - source
	local length = v:dot_product(direction)

	return source + direction * length
end

--- Returns a point along a ray after dividing it.
--- @param destination vector_old_c
--- @param ratio number
--- @return vector_old_c
function vector_old_c:divide_ray(destination, ratio)
	return (self * ratio + destination) / (1 + ratio)
end

--- Internally divide a ray.
--- @param source vector_old_c
--- @param destination vector_old_c
--- @param m number
--- @param n number
--- @return vector_old_c
local function vector_internal_division(source, destination, m, n)
	return vectorh((source.x*n + destination.x*m) / (m+n),
		(source.y*n + destination.y*m) / (m+n),
		(source.z*n + destination.z*m) / (m+n))
end

--- Returns a ray divided into a number of segments.
--- @param destination vector_old_c
--- @param segments number
--- @return table<number, vector_old_c>
function vector_old_c:segment_ray(destination, segments)
	local points = {}

	for i = 0, segments do
		points[i] = vector_internal_division(self, destination, i, segments - i)
	end

	return points
end

--- Returns the best source vector and destination vector to draw a line on-screen using world-to-screen.
--- @param destination vector_old_c
--- @param total_segments number
--- @return vector_old_c|nil, vector_old_c|nil
function vector_old_c:ray(destination, total_segments)
	total_segments = total_segments or 128

	local segments = {}
	local step = self:distance(destination) / total_segments
	local angle = self:angle_to(destination)
	local direction = angle:to_forward_vector()

	for i = 1, total_segments do
		table.insert(segments, self + (direction * (step * i)))
	end

	local src_screen_position = vectorh(0, 0, 0)
	local dst_screen_position = vectorh(0, 0, 0)
	local src_in_screen = false
	local dst_in_screen = false

	for i = 1, #segments do
		src_screen_position = segments[i]:to_screen()

		if src_screen_position ~= nil then
			src_in_screen = true

			break
		end
	end

	for i = #segments, 1, -1 do
		dst_screen_position = segments[i]:to_screen()

		if dst_screen_position ~= nil then
			dst_in_screen = true

			break
		end
	end

	if src_in_screen and dst_in_screen then
		return src_screen_position, dst_screen_position
	end

	return nil
end
--endregion

--region angle_vector_methods
--- Returns a forward vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_old_c
function angle_old_c:to_forward_vector()
	local degrees_to_radians = function(degrees) return degrees * math.pi / 180 end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))

	return vectorh(cp * cy, cp * sy, -sp)
end

--- Return an up vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_old_c
function angle_old_c:to_up_vector()
	local degrees_to_radians = function(degrees) return degrees * math.pi / 180 end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))

	return vectorh(cr * sp * cy + sr * sy, cr * sp * sy + sr * cy * -1, cr * cp)
end

--- Return a right vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_old_c
function angle_old_c:to_right_vector()
	local degrees_to_radians = function(degrees) return degrees * math.pi / 180 end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))

	return vectorh(sr * sp * cy * -1 + cr * sy, sr * sp * sy * -1 + -1 * cr * cy, -1 * sr * cp)
end

--- Return a backward vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_old_c
function angle_old_c:to_backward_vector()
	local degrees_to_radians = function(degrees) return degrees * math.pi / 180 end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))

	return -vectorh(cp * cy, cp * sy, -sp)
end

--- Return a left vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_old_c
function angle_old_c:to_left_vector()
	local degrees_to_radians = function(degrees) return degrees * math.pi / 180 end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))

	return -vectorh(sr * sp * cy * -1 + cr * sy, sr * sp * sy * -1 + -1 * cr * cy, -1 * sr * cp)
end

--- Return a down vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_old_c
function angle_old_c:to_down_vector()
	local degrees_to_radians = function(degrees) return degrees * math.pi / 180 end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))

	return -vectorh(cr * sp * cy + sr * sy, cr * sp * sy + sr * cy * -1, cr * cp)
end

--- Calculate where a vector is in a given field of view.
--- @param source_vector vector_old_c
--- @param target_vector vector_old_c
--- @return number
function angle_old_c:fov_to(source_vector, target_vector)
	local fwd = self:to_forward_vector();
	local delta = (target_vector - source_vector):normalized();
	local fov = math.acos(fwd:dot_product(delta) / delta:length());

	return math.max(0.0, math.deg(fov));
end
--endregion
--endregion

--region dependency: havoc_shader_1_5_0
--- @class shader_c
--- @field public r number
--- @field public g number
--- @field public b number
--- @field public h number
--- @field public s number
--- @field public l number
--- @field public a number
--- @field public update_method fun(shader: shader_c, space: number): void
--- @field public rgb_updated boolean
--- @field public hsl_updated boolean
local shader_c = {}
local shader_mt = {
	__index = shader_c,
	--- @param shader shader_c
	__call = function(shader, r, g, b, a)
		if (r ~= nil) then
			shader:set_r(r)
			shader:set_g(g)
			shader:set_b(b)
			shader:set_a(a)
		else
			return shader:unpack()
		end
	end
}

--- Returns a string representation of the shader's RGB values.
function shader_mt.__tostring(shader_object)
	return string.format("%s, %s, %s, %s", shader_object.r, shader_object.g, shader_object.b, shader_object.a)
end

--- Concatenates the shader in a string.
function shader_mt.__concat(shader_object)
	return string.format("%s, %s, %s, %s", shader_object.r, shader_object.g, shader_object.b, shader_object.a)
end

--- Create a new shader from RGBA.
--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @param automatically_update_spaces boolean
--- @return shader_c
function shader_c.rgb(r, g, b, a, automatically_update_spaces)
	if (a == nil) then
		a = 255
	end

	local object = shader_c.new(r, g, b, 0, 0, 0, a, automatically_update_spaces)

	object:validate_rgb_space()
	object:update_hsl_space()

	return object
end

--- Create a new shader from HSLA.
--- @param h number
--- @param s number
--- @param l number
--- @param a number
--- @param automatically_update_spaces boolean
--- @return shader_c
function shader_c.hsl(h, s, l, a, automatically_update_spaces)
	if (a == nil) then
		a = 255
	end

	local object = shader_c.new(0, 0, 0, h, s, l, a, automatically_update_spaces)

	object:validate_hsl_space()
	object:update_rgb_space()

	return object
end

--- Create a new shader from hex.
--- @param hex string
--- @param automatically_update_spaces boolean
--- @return shader_c
function shader_c.hex(hex, automatically_update_spaces)
	local r, g, b, a = shader_c.hex_to_rgb(hex)

	local object = shader_c.new(r, g, b, 0, 0, 0, a, automatically_update_spaces)

	object:validate_rgb_space()
	object:update_hsl_space()

	return object
end

--- Creates a new shader.
--- @param r number
--- @param g number
--- @param b number
--- @param h number
--- @param s number
--- @param l number
--- @param a number
--- @param automatically_update_spaces boolean
--- @return shader_c
function shader_c.new(r, g, b, h, s, l, a, automatically_update_spaces)
	automatically_update_spaces = automatically_update_spaces or true

	local update_method

	-- Either automatically update spaces each change or wait for a call to do so.
	if (automatically_update_spaces == true) then
		update_method = function(shader, space)
			if (space == 0) then
				shader:update_rgb_space()
			else
				shader:update_hsl_space()
			end
		end
	else
		update_method = function(shader, space)
			if (space == 0) then
				shader.rgb_updated = false
			else
				shader.hsl_updated = false
			end
		end
	end

	local properties = {
		r = r,
		g = g,
		b = b,
		h = h,
		s = s,
		l = l,
		a = a,
		update_method = update_method,
		rgb_updated = true,
		hsl_updated = true
	}

	return setmetatable(properties, shader_mt)
end

--- Clones the shader.
--- @return shader_c
function shader_c:clone()
	local properties = {
		r = self.r,
		g = self.g,
		b = self.b,
		h = self.h,
		s = self.s,
		l = self.l,
		a = self.a,
		rgb_updated = true,
		hsl_updated = true,
		update_method = self.update_method
	}

	return setmetatable(properties, shader_mt)
end

--- Unpacks the shader's RGBA properties.
--- @return number, number, number, number
function shader_c:unpack()
	return self.r, self.g, self.b, self.a
end

--- Converts a hex string into RGBA.
--- @param hex string
--- @return number, number, number, number
function shader_c.hex_to_rgb(hex)
	local length = hex:len()

	if (length == 3) then
		local insert = hex:sub(2)

		hex = hex .. insert .. insert
	elseif (length == 4) then
		hex = hex .. hex:sub(2)
	end

	hex = hex:gsub("#","")

	local r = tonumber("0x"..hex:sub(1,2))
	local g = tonumber("0x"..hex:sub(3,4))
	local b = tonumber("0x"..hex:sub(5,6))
	local a = tonumber("0x"..hex:sub(7,8))

	if (a == nil) then
		a = 255
	end

	return r, g, b, a
end

--- Updates shader spaces.
--- @return void
function shader_c:update_spaces()
	if (self.rgb_updated == false) then
		self:update_rgb_space()

		self.rgb_updated = true
	elseif (self.hsl_updated == false) then
		self:update_hsl_space()

		self.hsl_updated = true
	end
end

--- Updates the RGB space.
--- @return void
function shader_c:update_rgb_space()
	local r, g, b

	if (self.s == 0) then
		r, g, b = self.l, self.l, self.l
	else
		local function hue_to_rgb(p, q, t)
			if t < 0   then t = t + 1 end
			if t > 1   then t = t - 1 end
			if t < 1/6 then return p + (q - p) * 6 * t end
			if t < 1/2 then return q end
			if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end

			return p
		end

		local q = 0

		if (self.l < 0.5) then
			q = self.l * (1 + self.s)
		else
			q = self.l + self.s - self.l * self.s
		end

		local p = 2 * self.l - q
		local h = self.h / 360

		r = hue_to_rgb(p, q, h + 1/3)
		g = hue_to_rgb(p, q, h)
		b = hue_to_rgb(p, q, h - 1/3)
	end

	self.r = r * 255
	self.g = g * 255
	self.b = b * 255
end

--- Updates the shader's HSL space.
--- @return void
function shader_c:update_hsl_space()
	local r, g, b = self.r / 255, self.g / 255, self.b / 255
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local h, s, l

	l = (max + min) / 2

	if (max == min) then
		h, s = 0, 0
	else
		local d = max - min

		if (l > 0.5) then
			s = d / (2 - max - min)
		else
			s = d / (max + min)
		end

		if (max == r) then
			h = (g - b) / d

			if (g < b) then
				h = h + 6
			end
		elseif (max == g) then
			h = (b - r) / d + 2
		elseif (max == b) then
			h = (r - g) / d + 4
		end

		h = (h / 6) * 360
	end

	self.h, self.s, self.l = h, s, l or 255
end

--- Validates the shader's RGB space.
--- @return void
function shader_c:validate_rgb_space()
	self.r = math.min(255, math.max(0, self.r))
	self.g = math.min(255, math.max(0, self.g))
	self.b = math.min(255, math.max(0, self.b))
	self.a = math.min(255, math.max(0, self.a))
end

--- Validates the shader's HSL space.
--- @return void
function shader_c:validate_hsl_space()
	self.h = math.min(360, math.max(0, self.h))
	self.s = math.min(1, math.max(0, self.s))
	self.l = math.min(1, math.max(0, self.l))
	self.a = math.min(255, math.max(0, self.a))
end

--- Set's the shader's red channel.
--- @param r number
--- @return void
function shader_c:set_r(r)
	self.r = r

	self.update_method(self, 1)
end

--- Set's the shader's green channel.
--- @param g number
--- @return void
function shader_c:set_g(g)
	self.g = g

	self.update_method(self, 1)
end

--- Set's the shader's blue channel.
--- @param b number
--- @return void
function shader_c:set_b(b)
	self.b = b

	self.update_method(self, 1)
end

--- Set's the shader's hue property.
--- @param h number
--- @return void
function shader_c:set_h(h)
	self.h = h

	self.update_method(self, 0)
end

--- Set's the shader's saturation property.
--- @param s number
--- @return void
function shader_c:set_s(s)
	self.s = s

	self.update_method(self, 0)
end

--- Set's the shader's lightness property.
--- @param l number
--- @return void
function shader_c:set_l(l)
	self.l = l

	self.update_method(self, 0)
end

--- Set's the shader's alpha channel.
--- @param a number
--- @return void
function shader_c:set_a(a)
	self.a = a
end

--- Returns 0 for white, and 1 for black depending on whether a colour is most visible against white or black.
--- @param tolerance number
--- @return number
function shader_c:contrast(tolerance)
	tolerance = tolerance or 150

	local contrast = self.r * 0.213 + self.g * 0.715 + self.b * 0.072

	if (contrast < tolerance) then
		return 0
	end

	return 1
end

--- Shift the hue of the shader.
--- @param amount number
--- @return void
function shader_c:shift_hue(amount)
	self.h = (self.h + amount) % 360

	self.update_method(self, 0)
end

--- Shift the saturation of the shader--- @param amount number
--- @return void
function shader_c:shift_saturation(amount)
	self.s = math.min(1, math.max(0, self.s + amount))

	self.update_method(self, 0)
end

--- Shift the lightness of the shader.
--- @param amount number
--- @return void
function shader_c:shift_lightness(amount)
	self.l = math.min(1, math.max(0, self.l + amount))

	self.update_method(self, 0)
end

--- Lighten the shader.
--- @param amount number
--- @return void
function shader_c:lighten(amount)
	self.l = math.min(1, math.max(0, self.l + amount))

	self.update_method(self, 0)
end

--- Darken the shader.
--- @param amount number
--- @return void
function shader_c:darken(amount)
	self.l = math.min(1, math.max(0, self.l - amount))

	self.update_method(self, 0)
end

--- Saturate the shader.
--- @param amount number
--- @return void
function shader_c:saturate(amount)
	self.s = math.min(1, math.max(0, self.s + amount))

	self.update_method(self, 0)
end

--- Desaturate the shader.
--- @param amount number
--- @return void
function shader_c:desaturate(amount)
	self.s = math.min(1, math.max(0, self.s - amount))

	self.update_method(self, 0)
end

--- Fade the shader's opacity in.
--- @param amount number
--- @return void
function shader_c:fade_in(amount)
	if (self.a == 255) then
		return
	end

	self.a = self.a + amount

	if (self.a > 255) then
		self.a = 255
	end
end

--- Fade the shader's opacity out.
--- @param amount number
--- @return void
function shader_c:fade_out(amount)
	if (self.a == 0) then
		return
	end

	self.a = self.a - amount

	if (self.a < 0) then
		self.a = 0
	end
end

--- Returns true if the shader is invisible.
--- @return boolean
function shader_c:is_invisible()
	return self.a == 0
end

--- Returns true if the shader is visible.
--- @return boolean
function shader_c:is_visible()
	return self.a > 0
end
--endregion

--region dependency: havoc_timer_4_1_0
--- Timer table.
local timer = {
	--- @type fun(start:boolean, custom:table):timer_standard_c
	standard = nil,
	--- @type fun(start:boolean, count_from:number, custom:table):timer_countdown_c
	countdown = nil,
	--- @type fun(start:boolean, custom:table):timer_tick_c
	tick = nil
}

--region timer_standard
--- @class timer_standard_c
--- @field public started_at number Timer was started at.
--- @field public paused_at number Timer was paused at.
local timer_standard_c = {}
local timer_standard_mt = {
	__index = timer_standard_c,
	__call = function(timer_standard)
		if (timer_standard.started_at == nil) then
			return 0
		end

		if (timer_standard.paused_at ~= nil) then
			return timer_standard.paused_at - timer_standard.started_at
		end

		return globals.realtime() - timer_standard.started_at
	end
}

--- Instantiate timer_standard_c.
--- @param start boolean
--- @param custom table
--- @return timer_standard_c
function timer_standard_c.new(start, custom)
	start = start or false

	local properties = custom or {}

	properties.started_at = nil
	properties.paused_at = nil

	local timer = setmetatable(properties, timer_standard_mt)

	if (start == true) then
		timer:start()
	end

	return timer
end

--- Returns true if the timer was started.
--- @return boolean
function timer_standard_c:has_started()
	return self.started_at ~= nil
end

--- Returns true if the timer is paused.
--- @return boolean
function timer_standard_c:is_paused()
	return self.paused_at ~= nil
end

--- Fires the event callback once the timer has reached the time it was told to count to.
--- @param fire_at number
--- @param callback fun(timer: timer_standard_c): void
--- @return boolean
function timer_standard_c:event(fire_at, callback)
	if (self() >= fire_at) then
		callback(self)
	end
end

--- Returns true if the seconds argument is greater than or equal to the elapsed time.
--- @param seconds number
--- @return boolean
function timer_standard_c:elapsed(seconds)
	return self() >= seconds
end

--- Tell the timer to start.
--- Calling this while the timer has already started is functionally equivalent to calling :restart().
--- @return void
function timer_standard_c:start()
	self.started_at = globals.realtime()
end

--- Tell the timer to stop.
--- @return void
function timer_standard_c:stop()
	self.started_at = nil
	self.paused_at = nil
end

--- Tell the timer to restart.
--- @return void
function timer_standard_c:restart()
	self:stop()
	self:start()
end

--- Tell the timer to pause.
--- @return void
function timer_standard_c:pause()
	if (self.started_at == nil) then
		return
	end

	self.paused_at = globals.realtime()
end

--- Tell the timer to unpause.
--- @return void
function timer_standard_c:unpause()
	if (self.started_at == nil or self.paused_at == nil) then
		return
	end

	local paused_for = globals.realtime() - self.paused_at

	self.started_at = self.started_at + paused_for
	self.paused_at = nil
end

--- Tell the timer to toggle pause.
--- @return void
function timer_standard_c:toggle_pause()
	if (self.paused_at == nil) then
		self:pause()
	else
		self:unpause()
	end
end

timer.standard = timer_standard_c.new
--endregion

--region timer_tick
--- @class timer_tick_c
--- @field public started_at number Timer was started at.
--- @field public paused_at number Timer was paused at.
local timer_tick_c = {}
local timer_tick_mt = {
	__index = timer_tick_c,
	__call = function(timer_tick)
		if (timer_tick.started_at == nil) then
			return 0
		end

		if (timer_tick.paused_at ~= nil) then
			return timer_tick.paused_at - timer_tick.started_at
		end

		return globals.tickcount() - timer_tick.started_at
	end
}

--- Instantiate timer_tick_c.
--- @param start boolean
--- @param custom table
--- @return timer_tick_c
function timer_tick_c.new(start, custom)
	start = start or false

	local properties = custom or {}

	properties.started_at = nil
	properties.paused_at = nil

	local timer = setmetatable(properties, timer_tick_mt)

	if (start == true) then
		timer:start()
	end

	return timer
end

--- Returns true if the timer was started.
--- @return boolean
function timer_tick_c:has_started()
	return self.started_at ~= nil
end

--- Returns true if the timer is paused.
--- @return boolean
function timer_tick_c:is_paused()
	return self.paused_at ~= nil
end

--- Fires the event callback once the timer has reached the time it was told to count to.
--- @param fire_at number
--- @param callback fun(timer: timer_tick_c): void
--- @return boolean
function timer_tick_c:event(fire_at, callback)
	if (self() >= fire_at) then
		callback(self)
	end
end

--- Returns true if the seconds argument is greater than or equal to the elapsed time.
--- @param ticks number
--- @return boolean
function timer_standard_c:elapsed(ticks)
	return self() >= ticks
end

--- Tell the timer to start.
--- Calling this while the timer has already started is functionally equivalent to calling :restart().
--- @return void
function timer_tick_c:start()
	self.started_at = globals.tickcount()
end

--- Tell the timer to stop.
--- @return void
function timer_tick_c:stop()
	self.started_at = nil
	self.paused_at = nil
end

--- Tell the timer to restart.
--- @return void
function timer_tick_c:restart()
	self:stop()
	self:start()
end


--- Tell the timer to pause.
--- @return void
function timer_tick_c:pause()
	if (self.started_at == nil) then
		return
	end

	self.paused_at = globals.tickcount()
end

--- Tell the timer to unpause.
--- @return void
function timer_tick_c:unpause()
	if (self.started_at == nil or self.paused_at == nil) then
		return
	end

	local paused_for = globals.tickcount() - self.paused_at

	self.started_at = self.started_at + paused_for
	self.paused_at = nil
end

--- Tell the timer to toggle pause.
--- @return void
function timer_tick_c:toggle_pause()
	if (self.paused_at == nil) then
		self:pause()
	else
		self:unpause()
	end
end

timer.tick = timer_tick_c.new
--endregion

--region timer_countdown
--- @class timer_countdown_c
--- @field public started_at number Timer was started at.
--- @field public paused_at number Timer was paused at.
--- @field public expires_at number Timer expires at.
--- @field public count_from number Timer counts from this to 0.
local timer_countdown_c = {}
local timer_countdown_mt = {
	__index = timer_countdown_c,
	__call = function(timer_countdown)
		if (timer_countdown.started_at == nil) then
			return timer_countdown.count_from
		end

		if (timer_countdown.paused_at ~= nil) then
			return timer_countdown.expires_at - timer_countdown.paused_at
		end

		return timer_countdown.expires_at - globals.realtime()
	end
}

--- Instantiate timer_standard_c.
--- @param start boolean
--- @param custom table
--- @return timer_countdown_c
function timer_countdown_c.new(start, count_from, custom)
	start = start or false

	local properties = custom or {}

	properties.started_at = nil
	properties.paused_at = nil
	properties.expires_at = globals.realtime() + count_from
	properties.count_from = count_from

	local timer = setmetatable(properties, timer_countdown_mt)

	if (start == true) then
		timer:start()
	end

	return timer
end

--- Returns true if the timer was started.
--- @return boolean
function timer_countdown_c:has_started()
	return self.started_at ~= nil
end

--- Returns true if the timer is paused.
--- @return boolean
function timer_countdown_c:is_paused()
	return self.paused_at ~= nil
end

--- Fires the event callback once the timer has reached the time it was told to count to.
--- @param fire_at number
--- @param callback fun(timer: timer_countdown_c): void
--- @return boolean
function timer_countdown_c:event(fire_at, callback)
	if (self() <= fire_at) then
		callback(self)
	end
end

--- Returns true if the timer is 0 or less.
--- @return boolean
function timer_countdown_c:expired()
	return self() <= 0
end

--- Tell the timer to start.
--- Calling this while the timer has already started is functionally equivalent to calling :restart().
--- @return void
function timer_countdown_c:start()
	self.started_at = globals.realtime()
	self.expires_at = globals.realtime() + self.count_from
end

--- Tell the timer to stop.
--- @return void
function timer_countdown_c:stop()
	self.started_at = nil
	self.paused_at = nil
end

--- Tell the timer to restart.
--- @return void
function timer_countdown_c:restart()
	self:stop()
	self:start()
end


--- Tell the timer to pause.
--- @return void
function timer_countdown_c:pause()
	if (self.started_at == nil) then
		return
	end

	self.paused_at = globals.realtime()
end

--- Tell the timer to unpause.
--- @return void
function timer_countdown_c:unpause()
	if (self.started_at == nil or self.paused_at == nil) then
		return
	end

	local paused_for = globals.realtime() - self.paused_at

	self.started_at = paused_for + self.started_at
	self.expires_at = paused_for + self.expires_at
	self.paused_at = nil
end

--- Tell the timer to toggle pause.
--- @return void
function timer_countdown_c:toggle_pause()
	if (self.paused_at == nil) then
		self:pause()
	else
		self:unpause()
	end
end

timer.countdown = timer_countdown_c.new
--endregion
--endregion

--region dependency: havoc_console_1_0_0
--region command
local command_c = {}
local command_mt = {__index = command_c}

--- Instantiate a command object.
function command_c.new(name, description, options, on_input)
	local save_value
	local persist_value

	if (options.datatype ~= nil) then
		if (type(options.save_value) == "boolean") then
			save_value = options.save_value
		else
			save_value = true
		end

		if (save_value == true and type(options.persist_value) == "boolean") then
			persist_value = options.persist_value
		else
			persist_value = true
		end
	end

	local properties = {
		name = name, -- Command name.
		description = description, -- Command description.
		on_input = on_input, -- Command callback.
		on_reset = options.on_reset or nil, -- Command callback when input value is reset.
		datatype = options.datatype or nil, -- Command datatype.
		save_value = save_value, -- Save the input value.
		persist_value = persist_value, -- Persist values to database.
		value = options.default or nil, -- Command value.
		default = options.default or nil, -- Command default value.
		input_value = nil, -- Last value that was attempted to be set.
		special = options.special or false -- Will submit console object instead of input values to command.
	}

	local command = setmetatable(properties, command_mt)

	-- Fire the on_load event.
	if (options.on_load ~= nil) then
		options.on_load(command)
	end

	return command
end
--endregion

--region state
local state_c = {}
local state_mt = {__index = state_c}

--- Instantiate a state object.
function state_c.new()
	local properties = {
		problem = false, -- Console crashed processing a command.
		reason = nil -- Reason for crash to print to console.
	}

	local state = setmetatable(properties, state_mt)

	return state
end
--endregion

--region fps
--- @class fps_c
--- @field public frametimes table<number, number>
--- @field public fps_prev number
--- @field public value_prev number
--- @field public last_update_time number
--- @field public timer timer_tick_c
local fps_c = {}
local fps_mt = {
	__index = fps_c,
	--- Return the current FPS.
	--- @param fps fps_c
	--- @return number
	__call = function(fps)
		return fps:get()
	end
}

--- Instantiate a fps object.
--- @return fps_c
function fps_c.new()
	local properties = {
		frametimes = {},
		fps_prev = 0,
		value_prev = {},
		last_update_time = 0,
		timer = timer_tick_c.new(true)
	}

	local fps = setmetatable(properties, fps_mt)

	return fps
end

--- Get the current FPS.
--- @return number
function fps_c:get()
	local ft = globals.frametime()

	return math.floor(1 / ft)
end
--endregion
--endregion

--region illusion_renderer
--- @class illusion_renderer_c
local illusion_renderer_c = {}

--- Render a rectangle particle.
--- @param particle illusion_particle_c
--- @return void
function illusion_renderer_c.rectangle(particle)
	-- Define the scales at which to render the particle.
	local draw_dimensions = vectorh(
		particle.width / (particle.relation_camera_distance / 100),
		particle.height / (particle.relation_camera_distance / 100),
		0
	)

	-- Center-align the particle based on the draw dimensions.
	particle.screen_dimensions = particle.screen_dimensions - (draw_dimensions / 2)

	-- Render.
	render.rect_filled(
		particle.screen_dimensions.x, particle.screen_dimensions.y,
		draw_dimensions.x, draw_dimensions.y,
		color.new(particle.shader.r, particle.shader.g, particle.shader.b, particle.shader.a)
	)
end

--- Render a texture particle.
--- @param particle illusion_particle_c
--- @return void
function illusion_renderer_c.texture(particle)
	-- Define the scales at which to render the particle.
	local draw_dimensions = vectorh(
		particle.width / (particle.relation_camera_distance / 100),
		particle.height / (particle.relation_camera_distance / 100),
		0
	)

	-- Center-align the particle based on the draw dimensions.
	particle.screen_dimensions = particle.screen_dimensions - (draw_dimensions / 2)

	-- Render.
	render.image_ex(
		particle.texture,
		particle.screen_dimensions.x, particle.screen_dimensions.y,
		draw_dimensions.x, draw_dimensions.y,
		color.new(particle.shader.r, particle.shader.g, particle.shader.b, particle.shader.a)
	)
end

--- Render a circle particle.
--- @param particle illusion_particle_c
--- @return void
function illusion_renderer_c.circle(particle)
	local radius = math.max(0.5, particle.radius / (particle.relation_camera_distance / 100))

	if (radius >= 2) then
		--[[render.arc(
			particle.screen_dimensions.x, particle.screen_dimensions.y,
			radius, 0, particle.start_degrees, 360 * particle.percentage,
			color.new(particle.shader.r, particle.shader.g, particle.shader.b, particle.shader.a)
		)]]

		render.circle_filled(
			particle.screen_dimensions.x, particle.screen_dimensions.y,
			180, radius,
			color.new(particle.shader.r, particle.shader.g, particle.shader.b, particle.shader.a)
		)
	else
		render.rect_filled(
			particle.screen_dimensions.x, particle.screen_dimensions.y,
			radius * 2, radius * 2,
			color.new(particle.shader.r, particle.shader.g, particle.shader.b, particle.shader.a)
		)
	end
end

--- Render a circle outline particle.
--- @param particle illusion_particle_c
--- @return void
function illusion_renderer_c.circle_outline(particle)
	local radius = particle.radius / (particle.relation_camera_distance / 100)

	if (radius >= 2) then
		render.arc(
			particle.screen_dimensions.x, particle.screen_dimensions.y, 
			radius, radius + particle.thickness, particle.start_degrees, 360 * particle.percentage, 
			color.new(particle.shader.r, particle.shader.g, particle.shader.b, particle.shader.a)
		)
	else
		render.rect_filled(
			particle.screen_dimensions.x, particle.screen_dimensions.y,
			radius * 2, radius * 2,
			color.new(particle.shader.r, particle.shader.g, particle.shader.b, particle.shader.a)
		)
	end
end
--endregion

--region illusion_particle
--- @class illusion_particle_c
--- @field public id number Particle ID.
--- @field public shared illusion_shared_c Illusion shared properties.
--- @field public simulation illusion_simulation_c Illusion simulation properties.
--- @field public hook illusion_hook_c The particle's hook.
--- @field public origin vector_old_c Origin vector.
--- @field public shader shader_c Particle shader.
--- @field public type string Particle type (rectangle, texture, circle, circle_outline).
--- @field public width number Base particle width (shape rectangular).
--- @field public height number Base particle height (shape rectangular).
--- @field public texture number Particle texture (type texture).
--- @field public radius number Particle base radius (shape circular).
--- @field public start_degrees number Particle base start degrees (shape circular).
--- @field public percentage number Particle base percentage (shape circular).
--- @field public thickness number Particle base thickness (type circle_outline).
--- @field public onscreen boolean Particle is on the player's screen (according to world-to-screen and skip_offscreen).
--- @field public occluded boolean Particle is behind cover.
--- @field public dying boolean Particle is currently in the dying state.
--- @field public dead boolean Particle is dead and is ready to be removed.
--- @field public lifespan number Particle lifespan. Set to nil for no death (defaults to nil).
--- @field private lifespan_timer timer_standard_c Particle lifespan timer.
--- @field public always_visible boolean Particle should be visible even if occluded.
--- @field public skip_offscreen boolean Skip particles that are offscreen even if they could be rendered otherwise. Good for performance.
--- @field public max_render_distance number The farthest away a particle can be and still be rendered.
--- @field public on_frame fun(particle:illusion_particle_c): void Fired each frame.
--- @field public on_tick fun(particle:illusion_particle_c): void Fired each tick.
--- @field public on_kill fun(particle:illusion_particle_c): void Fired when a particle is killed.
--- @field public on_dead fun(particle:illusion_particle_c): void Fired when a particle is dead.
--- @field public fade_time number Seconds that a particle should take to fade out on death.
--- @field private death_timer timer_standard_c Timer that counts how long the particle has been dying for.
--- @field private alpha_at_death number Used for fading the particle out on death.
--- @field public relation_camera_distance number Distance between the particle and the camera.
--- @field public screen_dimensions vector_old_c Particle position onscreen.
--- @field public animator illusion_animator_c Illusion animator custom property (must be declared).
local illusion_particle_c = {}
local illusion_particle_mt = { __index = illusion_particle_c }

--- Instantiate an object of illusion_particle_c.
--- @param id number
--- @param shared illusion_shared_c
--- @param hook illusion_hook_c
--- @return illusion_particle_c
function illusion_particle_c.new(id, shared, simulation, hook)
	return setmetatable({
		-- Meta.
		id = id,
		shared = shared,
		simulation = simulation,
		hook = hook,
		-- General properties.
		origin = nil,
		shader = nil,
		type = "circle",
		-- Particle type options.
		width = 5,
		height = 5,
		texture = 0,
		radius = 5,
		start_degrees = 0,
		percentage = 1,
		thickness = 1,
		-- States.
		onscreen = false,
		occluded = true,
		dying = false,
		dead = false,
		-- Lifespan.
		lifespan = nil,
		lifespan_timer = timer_standard_c.new(true),
		-- Rendering options.
		always_visible = false,
		skip_offscreen = true,
		max_render_distance = 8192,
		-- Particle event callbacks.
		on_frame = nil,
		on_tick = nil,
		on_kill = nil,
		on_dead = nil,
		-- Particle death properties.
		fade_time = 0,
		death_timer = timer_standard_c.new(false),
		alpha_at_death = nil,
		-- Particle-camera relationship properties.
		relation_camera_distance = 0,
		-- Render.
		screen_dimensions = vectorh(0, 0, 0)
	}, illusion_particle_mt)
end

--- Kill the particle.
--- @param expedite_fade_time boolean
--- @return void
function illusion_particle_c:kill(expedite_fade_time)
	-- Particle has already been killed.
	if (self.dying == true) then
		return
	end

	-- Fade-out can be used.
	if (self.fade_time ~= nil and self.fade_time > 0) then
		-- Make the fade out faster.
		if (expedite_fade_time == true) then
			self.fade_time = self.fade_time / 2
		end

		self.dying = true
		self.alpha_at_death = self.shader.a

		self.death_timer:start()
	else
		self.dead = true
	end

	-- Fire on_kill event.
	if (self.on_kill ~= nil) then
		self.on_kill(self)
	end
end

--- Kill the particle if it is invisible.
--- @return void
function illusion_particle_c:kill_invisible()
	if (self.shader.a == 0) then
		self.dead = true
	end
end

--- Kill the particle if it is occluded.
--- @return void
function illusion_particle_c:kill_occluded()
	if (self.occluded == true) then
		self.dead = true
	end
end

--- Kill the particle if it is off-screen.
--- @return void
function illusion_particle_c:kill_offscreen()
	if (self.onscreen == false) then
		self.dead = true
	end
end

--- Process particle frame.
--- @return void
function illusion_particle_c:process()
	-- Determine and update the distance of particle to the camera.
	self.relation_camera_distance = self.origin:distance(self.shared.player_camera_position)

	-- Process the lifespan of the particle.
	self:process_lifespan()

	-- Process death if the particle is dead.
	self:process_death()

	-- Fire on_frame event.
	if (self.on_frame ~= nil) then
		self.on_frame(self)
	end

	-- Process tick for this frame.
	if (self.on_tick ~= nil and self.hook.tick_this_frame == true) then
		self.on_tick(self)
	end

	-- Set screen position of particle.
	self.screen_dimensions = self.origin:to_screen()

	-- Skip offscreen particles.
	if (self.skip_offscreen == true and self.screen_dimensions ~= nil) then
		if (
			self.screen_dimensions.x < 0 or
			self.screen_dimensions.x > self.shared.resolution.x or
			self.screen_dimensions.y < 0 or
			self.screen_dimensions.y > self.shared.resolution.y
		) then
			self.screen_dimensions = nil
		end
	end

	-- Particle is not onscreen.
	if (self.screen_dimensions == nil) then
		self.onscreen = false

		return
	else
		self.onscreen = true
	end

	-- Particle is beyond the maximum render distance.
	if (self.relation_camera_distance > self.max_render_distance) then
		return
	end

	-- Particle is invisible.
	if (self.shader.a == 0) then
		return
	end

	-- Process vischeck.
	if (self.always_visible == true) then
		self.occluded = false
	else
		if (self.simulation.vischeck_this_frame == true) then
			self:process_vischeck()
		end
	end

	-- Particle is occluded.
	if (self.occluded == true) then
		return
	end

	-- Render particle.
	self:render()
end

--- Process particle vischeck.
--- @return void
function illusion_particle_c:process_vischeck()
	local trace_fraction = 0

	-- Process vischeck for first and thirdperson.
	-- We don't want to ignore the local player in thirdperson.
	if (self.shared.is_thirdperson == true) then
		trace_fraction = self.shared.player_camera_position:trace_line_to(self.origin)
	else
		trace_fraction = self.shared.player_camera_position:trace_line_to(self.origin, self.shared.player_eid)
	end

	self.occluded = trace_fraction < 1
end

--- Process the particle's lifespan.
--- @private
--- @return void
function illusion_particle_c:process_lifespan()
	-- Particle is already dying, or has no lifespan.
	if (self.dying == true or self.lifespan == nil) then
		return
	end

	-- Kill the particle once it has expired.
	self.lifespan_timer:event(self.lifespan, function()
		self:kill()
	end)
end

--- Fade the particle out if it is dying.
--- @private
--- @return void
function illusion_particle_c:process_death()
	-- Particle is not yet dying.
	if (self.dying == false) then
		return
	end

	-- Kill the particle once it has finished dying.
	self.death_timer:event(self.fade_time, function()
		self.dead = true

		return
	end)

	-- Fade out the particle linear to the death timer.
	self.shader.a = self.alpha_at_death * (0 - (self.death_timer() - self.fade_time) / self.fade_time)
end

--- Render the particle.
--- @return void
function illusion_particle_c:render()
	-- Synchronise the shader's RGB/HSL colour spaces.
	self.shader:update_spaces()

	-- Render the particle.
	illusion_renderer_c[self.type](self)
end
--endregion

--region illusion_shared
--- @class illusion_shared_c
--- @field public player_eid number Player entity index.
--- @field public is_thirdperson boolean Player is in thirdperson.
--- @field public is_dead boolean Player is dead.
--- @field public is_scoped boolean Player is scoped in.
--- @field public is_fake_ducking boolean Player is fake ducking.
--- @field public player_origin vector_old_c Player absolute origin.
--- @field public player_eye_position vector_old_c Player eye position.
--- @field public player_camera_position vector_old_c Player camera position.
--- @field public player_camera_angles angle_old_c Player camera angles.
--- @field public player_speed number Player speed (magnitude of m_vecVelocity).
--- @field public player_velocity vector_old_c Player vector velocity (m_vecVelocity).
--- @field public resolution vector_old_c Screen resolution.
--- @field public camera_aspect number Camera aspect.
--- @field public fov number Camera field of view.
--- @field public scope_fov number Camera scoped field of view.
--- @field public scope_level boolean Player scope level.
--- @field public zoom_modifier number Gamesense zoom modifier.
--- @field public observer_eid number Observer entity index.
--- @field public observer_mode number Observer mode. 0 = Alive, 1 = Death cam, 2 = Freeze cam, 3 = Fixed cam, 4 = First person spectator, 5 = Third person spectator, 6 = Free mode.
--- @field public observing_team number The team the player is on or spectating.
--- @field public observing_self boolean Player is observing themself.
local illusion_shared_c = {}
local illusion_shared_mt = { __index = illusion_shared_c }

--- Instantiate an object of shared_c.
--- @return illusion_shared_c
function illusion_shared_c.new()
	return setmetatable({
		-- Player general.
		player_eid = nil,
		player_eweapon = nil,
		-- Player states.
		is_thirdperson = nil,
		is_dead = nil,
		is_scoped = nil,
		is_fake_ducking = nil,
		-- Player vectors, angles, and motion.
		player_origin = vectorh(0, 0, 0),
		player_eye_position = vectorh(0, 0, 0),
		player_camera_position = vectorh(0, 0, 0),
		player_camera_angles = angle(0, 0, 0),
		player_speed = nil,
		player_velocity = vectorh(0, 0, 0),
		-- Screen.
		resolution = vectorh(0, 0, 0),
		camera_aspect = nil,
		fov = nil,
		scope_fov = nil,
		scope_level = nil,
		zoom_modifier = nil,
		-- Observer.
		observer_eid = nil,
		observer_mode = nil,
		observing_team = nil,
		observing_self = nil,
	}, illusion_shared_mt)
end

--- Updates all shared properties from the game.
--- @return void
function illusion_shared_c:sync()
	-- Update player entity index.
	self.player_eid = entitylist.get_local_player()
	if not self.player_eid then return end

	self.player_eweapon = entitylist.get_weapon_by_player(self.player_eid)
	if not self.player_eweapon then return end

	-- Player is fake ducking.
	self.is_fake_ducking = ui.get_keybind_state(keybinds.fakeduck)

	-- Player absolute origin.
	self.player_origin(self.player_eid:get_absorigin().x, self.player_eid:get_absorigin().y, self.player_eid:get_absorigin().z)

	-- Correct for fake ducking in eye position vector.
	if (self.is_fake_ducking == true) then
		self.player_eye_position = self.player_origin:clone_offset(0, 0, 46)
	else
		self.player_eye_position(engine.get_view_angles().x, engine.get_view_angles().y, engine.get_view_angles().z)
	end

	-- Update camera position.
	self.player_camera_position(self.player_eid:get_shoot_pos().x, self.player_eid:get_shoot_pos().y, self.player_eid:get_shoot_pos().z)

	-- Update camera angles.
	self.player_camera_angles(self.player_eid:get_angles().x, self.player_eid:get_angles().y, self.player_eid:get_angles().z)

	-- Update player velocity.
	self.player_velocity(self.player_eid:get_velocity().x, self.player_eid:get_velocity().y, self.player_eid:get_velocity().z)

	-- Update player speed.
	self.player_speed = self.player_velocity:magnitude()

	-- Compensate for fake ducking.
	if (self.is_fake_ducking == true) then
		local thirdperson_hotkey = keybinds.thirdperson

		self.is_thirdperson = ui.get_keybind_state(thirdperson_hotkey)
	else
		-- Update is thirdperson.
		self.is_thirdperson = self.player_eye_position:distance(self.player_camera_position) > 5
	end

	-- Update resolution.
	self.resolution(engine.get_screen_width(), engine.get_screen_height())

	-- Update camera aspect.
	self.camera_aspect = self.resolution.x / self.resolution.y

	-- Update field of view.
	self.fov = ui.get_int("Esp.fov")

	-- Update scoped field of view.
	self.scope_fov = self.player_eid:get_prop_int("CBasePlayer", "m_iFOV")

	-- Correct unscoped field of view.
	if (self.scope_fov == 0 or self.scope_fov == 90) then
		self.scope_fov = self.fov
	end

	-- Update is scoped.
	self.is_scoped = not self.player_eweapon:is_non_aim() and self.player_eid:is_scoped() and true or false

	-- Update scope level.
	self.scope_level = 0

	-- Set scope levels.
	if (self.is_scoped == true and self.scope_fov == 40) then
		self.scope_level = 1
	elseif (self.is_scoped == true and self.scope_fov == 15) then
		self.scope_level = 2
	end

	-- Update zoom modifier.
	self.zoom_modifier = 0

	-- Update observer mode.
	self.observer_mode = self.player_eid:get_prop_int("CBasePlayer", "m_iObserverMode")

	-- Get the observer target. Default to local player unless they are spectating.
	local observer_target = self.player_eid

	-- Player is viewing themselves.
	local observing_self = true

	-- Set observing self.
	self.observing_self = observing_self

	-- Get the observer team.
	local observer_team = observer_target:get_team()

	-- Set the shared observer target.
	self.observer_eid = observer_target

	-- Set the shared observer team.
	self.observing_team = observer_team

	-- Update is dead.
	self.is_dead = self.observer_mode ~= 0
end
--endregion

--region illusion_simulation
--- @class illusion_simulation_c
--- @field public frametime number Simulation current frametime.
--- @field public delta number Simulation frame difference.
--- @field public frame number Simulation current frame.
--- @field public fps fps_c Simulation FPS.
--- @field public vischeck_interval number Trace line interval.
--- @field public vischeck_this_frame boolean Perform trace lines this frame.
local illusion_simulation_c = {}
local illusion_simulation_mt = { __index = illusion_simulation_c }

--- Instantiate an object of illusion_simulation_c.
--- @return illusion_simulation_c
function illusion_simulation_c.new()
	return setmetatable({
		frametime = 0,
		delta = 0,
		frame = 0,
		fps = fps_c.new(),
		vischeck_interval = 0,
		vischeck_this_frame = nil
	}, illusion_simulation_mt)
end

--- Update simulation properties.
--- @return void
function illusion_simulation_c:sync()
	self.frametime = globals.absoluteframetime()
	self.delta = globals.absoluteframetime() * 100
	self.frame = self.frame + 1

	self:update_vischeck()
end

--- Update vischeck properties.
---
--- At higher FPS this will cause particles to skip doing vischecking more often.
--- This is potentially the stupidest FPS optimization in this project. It is literally designed to make
--- your FPS worse the lower your FPS gets. However it also works wonderfully.
---
--- @return void
function illusion_simulation_c:update_vischeck()
	-- Determine the interval at which to process vischecking.
	local vischeck_interval = math.max(1, math.floor(self.fps() / 66))

	-- Update interval.
	self.vischeck_interval = vischeck_interval

	-- Update whether vischecking occurs on the current frame.
	self.vischeck_this_frame = self.frame % vischeck_interval == 0
end
--endregion

--region illusion_particle_manager
--- @class illusion_particle_manager_c
--- @field public particles table<number, illusion_particle_c> Particle table.
--- @field public total_spawned number Total particles spawned.
--- @field public total_alive number Total particles alive.
--- @field public soft_limit number Limit of particles (kill particles with fade_time).
--- @field public hard_limit number Hard limit of particles (prevents spawning, does not respect fade_time).
--- @field public unculled number The number of particles this frame that are not culled.
local illusion_particle_manager_c = {}
local illusion_particle_manager_mt = { __index = illusion_particle_manager_c }

--- Instantiate an object of particle_manager_c.
--- @return illusion_particle_manager_c
function illusion_particle_manager_c.new()
	return setmetatable({
		particles = {},
		total_spawned = 0,
		total_alive = 0,
		unculled = 0,
		soft_limit = 512,
		hard_limit = 1024,
		cull_next_particle = false,
		cull_particle_mode = 0
	}, illusion_particle_manager_mt)
end

--- Process particles for the current frame.
--- @return void
function illusion_particle_manager_c:process()
	-- Number of alive particles this frame.
	local unculled = self.total_alive

	-- Age-ascending ordered particle processing for culling particles.
	for _, particle in pairs(self:order_for_culling()) do
		if (unculled > self.hard_limit) then
			-- Particle must be removed immediately.
			self:remove(particle)

			unculled = unculled - 1
		elseif (unculled > self.soft_limit) then
			-- Particle may be killed in the standard way.
			-- Expedite the fade-out time for the particle to improve performance.
			particle:kill(true)

			unculled = unculled - 1
		end
	end

	-- Distance-descending ordered particle processing for rendering particles.
	for _, particle in pairs(self:order_for_rendering()) do
		if (particle.dead == true) then
			-- Particle is dead and should be removed this frame.
			self:remove(particle)
		else
			-- Process and render the particle.
			particle:process()
		end
	end
end

--- Add a particle.
--- @param particle illusion_particle_c
--- @return void
function illusion_particle_manager_c:add(particle)
	self.particles[particle.id] = particle
	self.total_spawned = self.total_spawned + 1
	self.total_alive = self.total_alive + 1

	particle.hook:add(particle)
end

--- Remove the particle.
--- @param particle illusion_particle_c
--- @return void
function illusion_particle_manager_c:remove(particle)
	self.particles[particle.id] = nil
	self.total_alive = self.total_alive - 1
	
	particle.hook:remove(particle)
end

--- Returns all particles ordered by farthest-closest.
--- @return table<number, illusion_particle_c>
function illusion_particle_manager_c:order_for_rendering()
	local ordered = {}

	for _, particle in spairs(self.particles, function(particles, a, b)
		return particles[b].relation_camera_distance < particles[a].relation_camera_distance
	end) do
		table.insert(ordered, particle)
	end

	return ordered
end

--- Returns all particles ordered by oldest-youngest.
--- @return table<number, illusion_particle_c>
function illusion_particle_manager_c:order_for_culling()
	local ordered = {}

	for _, particle in spairs(self.particles, function(particles, a, b)
		return particles[b].id > particles[a].id
	end) do
		table.insert(ordered, particle)
	end

	return ordered
end
--endregion

--region illusion_state
--- @class illusion_state_c
--- @field public connected boolean Player is connected to a server and is in-game.
--- @field public crashed boolean Engine has crashed and cannot be used.
--- @field public enabled boolean Engine is enabled and can be used.
local illusion_state_c = {}
local illusion_state_mt = { __index = illusion_state_c }

--- Instantiate an object of illusion_state_c.
--- @return illusion_state_c
function illusion_state_c.new()
	return setmetatable({
		connected = false,
		crashed = false,
		enabled = true
	}, illusion_state_mt)
end

--- Update the connected state.
--- @return void
function illusion_state_c:sync()
	self.connected = entitylist.get_local_player() ~= nil
end

--- Returns true if Illusion may be used at this time.
--- @return boolean
function illusion_state_c:available()
	return self.connected == true and self.crashed == false and self.enabled == true
end
--endregion

--region illusion_hook
--- @class illusion_hook_c
--- @field public name string Hook name.
--- @field public particles table<number, illusion_particle_c> Particle table.
--- @field public total_spawned number Total particles spawned.
--- @field public total_alive number Total particles alive.
--- @field public tick_interval number Tick interval of all particles belonging to the hook (default 0.03125, or 32 ticks per second).
--- @field public tick_interval_timer timer_standard_c Tick interval timer.
--- @field public tick_this_frame boolean Process ticks for particles this frame.
local illusion_hook_c = {}
local illusion_hook_mt = { __index = illusion_hook_c }

--- Instantiate an object of illusion_hook_c.
--- @param name string
--- @return illusion_hook_c
function illusion_hook_c.new(name)
	return setmetatable({
		name = name,
		particles = {},
		total_spawned = 0,
		total_alive = 0,
		tick_interval = 0.03125,
		tick_interval_timer = timer_standard_c.new(true),
		tick_this_frame = false
	}, illusion_hook_mt)
end

--- Add a particle.
--- @param particle illusion_particle_c
--- @return void
function illusion_hook_c:add(particle)
	self.particles[particle.id] = particle
	self.total_spawned = self.total_spawned + 1
	self.total_alive = self.total_alive + 1
end

--- Remove a particle.
--- @param particle illusion_particle_c
--- @return void
function illusion_hook_c:remove(particle)
	self.particles[particle.id] = nil
	self.total_alive = self.total_alive - 1
end

--- Culls the first particle in the particle render queue that is not dying.
--- @return void
function illusion_hook_c:cull()
	for _, particle in pairs(self.particles) do
		if (particle.dying == false) then
			particle:kill()

			break
		end
	end
end

--- Sets tick_this_frame to true if on_tick can be processed this frame.
--- @return void
function illusion_hook_c:update_tick_this_frame() 
	self.tick_interval_timer:event(self.tick_interval, function()
		self.tick_this_frame = true

		self.tick_interval_timer:restart()

		return
	end)

	self.tick_this_frame = false
end
--endregion

--region illusion_hook_manager
--- @class illusion_hook_manager_c
--- @field public hooks table <number, illusion_hook_c>
local illusion_hook_manager_c = {}
local illusion_hook_manager_mt = { __index = illusion_hook_manager_c }

--- Instantiate an object of illusion_hook_manager_c.
--- @return illusion_hook_manager_c
function illusion_hook_manager_c.new()
	return setmetatable({
		hooks = {}
	}, illusion_hook_manager_mt)
end

--- Create a new hook.
--- @param hook_name string
--- @return illusion_hook_c
function illusion_hook_manager_c:create(hook_name)
	local hook = illusion_hook_c.new(hook_name)

	table.insert(self.hooks, hook)

	return hook
end
--endregion

--region illusion_debug_panel
--- @class illusion_debug_panel_c
--- @field public enabled boolean
--- @field public shared illusion_shared_c
--- @field public groups table
--- @field public colors table<string, shader_c>
local illusion_debug_panel_c = {}
local illusion_debug_panel_mt = { __index = illusion_debug_panel_c }

--- Instantiate an object of illusion_debug_panel_c.
--- @return illusion_debug_panel_c
function illusion_debug_panel_c.new(shared)
	return setmetatable({
		enabled = false,
		shared = shared,
		groups = {},
		colors = {
			theme = shader_c.rgb(219, 184, 3),
			blue = shader_c.rgb(18, 217, 255),
			purple = shader_c.rgb(173, 153, 255),
			normal = shader_c.rgb(235, 235, 235),
			good = shader_c.rgb(138, 255, 77),
			notice = shader_c.rgb(219, 184, 3),
			warning = shader_c.rgb(255, 163, 71),
			error = shader_c.rgb(255, 71, 71)
		}
	}, illusion_debug_panel_mt)
end

--- Render a debug line.
--- @param group string
--- @param title string
--- @param color string
--- @vararg string
--- @return void
function illusion_debug_panel_c:line(group, title, color, text)
	if (self.groups[group] == nil) then
		self.groups[group] = {}
	end

	self.groups[group][title] = {
		title = title,
		color = self.colors[color],
		text = text
	}
end

--- Render the debug panel.
--- @return void
function illusion_debug_panel_c:render()
	-- Panel is not enabled.
	if (self.enabled == false) then
		return
	end

	local window_position = vectorh(
		self.shared.resolution.x / 5,
		180
	)

	local window_dimensions = vectorh(400, 0)

	self:render_line(shader_c.rgb(20, 20, 20, 240), window_position, window_dimensions, {
		title = "Havoc Illusion Debug Panel",
		color = self.colors["theme"],
		text = ""
	})

	window_position.y = window_position.y + 20

	for group_name, group in pairs(self.groups) do
		self:render_line(shader_c.rgb(20, 20, 20, 200), window_position, window_dimensions, {
			title = group_name,
			color = self.colors["normal"],
			text = ""
		})

		window_position.y = window_position.y + 20

		local line_index = 0

		for _, line in pairs(group) do
			line_index = line_index + 1

			local line_shader

			if (line_index % 2 == 0) then
				line_shader = shader_c.rgb(20, 20, 20, 100)
			else
				line_shader = shader_c.rgb(20, 20, 20, 50)
			end

			self:render_line(line_shader, window_position, window_dimensions, line)

			window_position.y = window_position.y + 20
		end
	end
end

--- Render a line.
--- @param background shader_c
--- @param line table
function illusion_debug_panel_c:render_line(background, window_position, window_dimensions, line)
	render.rect_filled(
		window_position.x, window_position.y,
		window_dimensions.x, 20,
		color.new(background.r, background.g, background.b, background.a)
	)

	--[[renderer.text(
		window_position.x + 10, window_position.y + 4,
		line.color.r, line.color.g, line.color.b, line.color.a,
		"l", 0,
		line.title
	)

	renderer.text(
		window_position.x + window_dimensions.x - 10, window_position.y + 4,
		line.color.r, line.color.g, line.color.b, line.color.a,
		"r", 0,
		line.text
	)]]
end
--endregion

--region illusion_animator
--- @class illusion_animator_c
--- @field private particle illusion_particle_c Particle to animate.
--- @field private float_timer timer_standard_c Times floating animations as they require consistent timing.
--- @field public orbit_angle angle_old_c Current orbit yaw.
local illusion_animator_c = {}
local illusion_animator_mt = { __index = illusion_animator_c }

--- Creates a new animator instance.
--- @param particle illusion_particle_c
--- @return void
local function illusion_animator(particle)
	return setmetatable({
		particle = particle,
		float_timer = timer_standard_c.new(true),
		orbit_angle = angle(0, 0, 0)
	}, illusion_animator_mt)
end

--- Orbit a given target vector at a given ideal orbit distance. Optional collision detection that dynamically reduces the orbit distance.
--- @param center_vector vector_old_c
--- @param particle_speed number
--- @param ideal_distance number
--- @param options table<string, any>
function illusion_animator_c:orbit(center_vector, particle_speed, ideal_distance, options)
	options = options or {}

	local orbit_vector = self:get_orbit_vector(
		center_vector,
		options.speed,
		ideal_distance,
		options.traces,
		options.collision,
		options.ignore
	)

	self:move_target(orbit_vector, particle_speed)
end

--- Orbit a given target vector at a given ideal orbit distance and ease the movement. Optional collision detection that dynamically reduces the orbit distance.
--- @param center_vector vector_old_c
--- @param particle_speed number
--- @param rigidity number
--- @param ideal_distance number
--- @param options table<string, any>
function illusion_animator_c:orbit_easing(center_vector, particle_speed, rigidity, ideal_distance, options)
	options = options or {}

	local orbit_vector = self:get_orbit_vector(
		center_vector,
		options.speed,
		ideal_distance,
		options.traces,
		options.collision,
		options.ignore
	)

	self:move_target_easing(orbit_vector, particle_speed, rigidity)
end

--- Returns the current orbit vector for this animator's current instance.
--- @param center_vector vector_old_c
--- @param orbit_speed number
--- @param ideal_distance number
--- @param orbit_traces number
--- @param adjust_orbit boolean
--- @param ignore_entity_trace number
function illusion_animator_c:get_orbit_vector(center_vector, orbit_speed, ideal_distance, orbit_traces, adjust_orbit, ignore_entity_trace)
	orbit_speed = orbit_speed or 1
	orbit_traces = orbit_traces or 24

	-- Dynamically adjust orbit distance based on walls that the particle would otherwise pass through.
	if (adjust_orbit == true) then
		-- This will be the distance the particle will orbit at.
		local lowest_distance = ideal_distance

		-- Determine the real orbit distance based on collisions.
		for i = 1, orbit_traces do
			local orbit_angle = angle(0, 360 / orbit_traces * i, 0)
			local orbit_vector = center_vector + orbit_angle:to_forward_vector() * ideal_distance
			local collision_trace = center_vector:trace_line_to(orbit_vector, ignore_entity_trace)
			local traced_distance = ideal_distance * collision_trace

			-- This trace was shorter than the previous.
			if (traced_distance < lowest_distance) then
				lowest_distance = traced_distance
			end
		end

		-- Move the current orbit yaw.
		self.orbit_angle.y = (self.orbit_angle.y + orbit_speed * self.particle.simulation.delta) % 360

		-- Determine the current target vector.
		return center_vector + (self.orbit_angle:to_forward_vector() * lowest_distance)
	end
end

--- Floating animation on the X axis.
--- @param amplitude number
--- @param frequency number
--- @return void
function illusion_animator_c:float_x(amplitude, frequency)
	self.particle.origin.x = self.particle.origin.x +
		math.sin(self.float_timer() * math.pi * frequency) * amplitude * self.particle.simulation.delta
end

--- Floating animation on the Y axis.
--- @param amplitude number
--- @param frequency number
--- @return void
function illusion_animator_c:float_y(amplitude, frequency)
	self.particle.origin.y = self.particle.origin.y +
		math.sin(self.float_timer() * math.pi * frequency) * amplitude * self.particle.simulation.delta
end

--- Floating animation on the Z axis.
--- @param amplitude number
--- @param frequency number
--- @return void
function illusion_animator_c:float_z(amplitude, frequency)
	self.particle.origin.z = self.particle.origin.z +
		math.sin(self.float_timer() * math.pi * frequency) * amplitude * self.particle.simulation.delta
end

--- Move at a given speed toward a target vector.
--- @param target_vector vector_old_c
--- @param speed number
--- @return void
function illusion_animator_c:move_target(target_vector, speed)
	self.particle.origin = self.particle.origin + (target_vector - self.particle.origin) * speed * self.particle.simulation.delta
end

--- Move at a given speed, with easing at a given rigidity, toward a target vector.
--- @param target_vector vector_old_c
--- @param speed number
--- @param rigidity number
--- @return void
function illusion_animator_c:move_target_easing(target_vector, speed, rigidity)
	self.particle.origin = self.particle.origin + (target_vector - self.particle.origin) * rigidity * speed * self.particle.simulation.delta
end

--- Move at a given speed toward a forward vector.
--- @param forward_vector vector_old_c
--- @param speed number
--- @return void
function illusion_animator_c:move_forward(forward_vector, speed)
	self.particle.origin = self.particle.origin + forward_vector * speed * self.particle.simulation.delta
end

--- Move at a given speed, with easing at a given rigidity, toward a forward vector.
--- @param forward_vector vector_old_c
--- @param speed number
--- @param rigidity number
--- @return void
function illusion_animator_c:move_forward_easing(forward_vector, speed, rigidity)
	self.particle.origin = self.particle.origin + forward_vector * rigidity * speed * self.particle.simulation.delta
end
--endregion


--region illusion
--- @class illusion_c
--- @field public version string Illusion version (SemVer 2.0).
--- @field public enabled boolean
--- @field public shared illusion_shared_c Illusion shared properties.
--- @field public simulation illusion_simulation_c Illusion simulation properties.
--- @field public particle_manager illusion_particle_manager_c Illusion particle manager.
--- @field public hook_manager illusion_hook_manager_c Illusion hook manager.
--- @field public state illusion_state_c Illusion state manager.
--- @field public console console_c Illusion console.
--- @field public panic panic_c Illusion panic module.
--- @field public debug_panel illusion_debug_panel_c Illusion debug panel.
local illusion_c = {}
local illusion_mt = { __index = illusion_c }

--- Instantiate an object of illusion_c.
--- @return illusion_c
function illusion_c.new()
	local shared = illusion_shared_c.new()

	return setmetatable({
		version = "1.0.1",
		shared = shared,
		simulation = illusion_simulation_c.new(),
		particle_manager = illusion_particle_manager_c.new(),
		hook_manager = illusion_hook_manager_c.new(),
		state = illusion_state_c.new(),
		console = function() return 0 end,
		panic = panic_c.new(function(console, state)
			cheat.notify("The render engine encountered a fatal error and has been shut down.")

			state.crashed = true
		end),
		debug_panel = illusion_debug_panel_c.new(shared)
	}, illusion_mt):init()
end

--- illusion_c constructor method.
--- @return void
function illusion_c:init()
	-- Update state.
	self.state:sync()

	-- Update simulation.
	self.simulation:sync()

	-- Update shared properties.
	self.shared:sync()

	return self
end

--- Process the current frame.
--- @return void
function illusion_c:process()
	-- Update state.
	self.state:sync()

	-- Engine is not available for use.
	if (self.state:available() == false) then
		return
	end

	-- Update simulation.
	self.simulation:sync()

	-- Update shared properties.
	self.shared:sync()
	
	-- Process all hook tick rates.
	self:process_hook_tick_rate()

	-- Process particle frames and ticks.
	self.particle_manager:process()

	-- Set debug lines.
	self:debug_lines()

	-- Render debug panel.
	self.debug_panel:render()
end

--- Process the current tick.
--- @return void
function illusion_c:process_hook_tick_rate()
	for _, hook in pairs (self.hook_manager.hooks) do
		hook:update_tick_this_frame()
	end
end

--- Set debug lines.
--- @return void
function illusion_c:debug_lines()
	self.debug_panel:line("player", "entity index", "normal", self.shared.player_eid)

	self.debug_panel:line("player states", "is thirdperson", "normal", self.shared.is_thirdperson and "yes" or "no")
	self.debug_panel:line("player states", "is dead", "normal", self.shared.is_dead and "yes" or "no")
	self.debug_panel:line("player states", "is scoped", "normal", self.shared.is_scoped and "yes" or "no")
	self.debug_panel:line("player states", "is fake ducking", "normal", self.shared.is_fake_ducking and "yes" or "no")

	self.debug_panel:line("player world info", "origin", "normal", self.shared.player_origin:rounded_zero())
	self.debug_panel:line("player world info", "eye position", "normal", self.shared.player_eye_position:rounded_zero())
	self.debug_panel:line("player world info", "camera position", "normal", self.shared.player_camera_position:rounded_zero())
	self.debug_panel:line("player world info", "camera angles", "normal", self.shared.player_camera_angles:rounded_zero())
	self.debug_panel:line("player world info", "speed", "normal", math.round(self.shared.player_speed, 0))
	self.debug_panel:line("player world info", "velocity vector", "normal", self.shared.player_velocity:rounded_zero())

	self.debug_panel:line("screen", "resolution", "normal", string.format("%sx%s", self.shared.resolution.x, self.shared.resolution.y))
	self.debug_panel:line("screen", "camera aspect", "normal", math.round(self.shared.camera_aspect, 4))
	self.debug_panel:line("screen", "field of view", "normal", math.round(self.shared.fov, 0))
	self.debug_panel:line("screen", "scoped field of view", "normal", math.round(self.shared.scope_fov, 0))
	self.debug_panel:line("screen", "scope level", "normal", self.shared.scope_level)
	self.debug_panel:line("screen", "scoped field of view modifier", "normal", math.round(self.shared.zoom_modifier, 0))

	self.debug_panel:line("observer", "entity index", "normal", self.shared.observer_eid)
	self.debug_panel:line("observer", "mode", "normal", self.shared.observer_mode)
	self.debug_panel:line("observer", "team", "normal", self.shared.observing_team)
	self.debug_panel:line("observer", "observing self", "normal", self.shared.observing_self and "yes" or "no")

	self.debug_panel:line("particle manager", "total spawned", "normal", self.particle_manager.total_spawned)

	local total_alive_color = "normal"

	if (self.particle_manager.total_alive >= self.particle_manager.hard_limit) then
		total_alive_color = "warning"
	elseif (self.particle_manager.total_alive >= self.particle_manager.soft_limit) then
		total_alive_color = "notice"
	end

	self.debug_panel:line("particle manager", "total alive", total_alive_color, self.particle_manager.total_alive)

	local soft_limit_color = "normal"

	if (self.particle_manager.soft_limit >= 8192) then
		soft_limit_color = "error"
	elseif (self.particle_manager.soft_limit >= 4096) then
		soft_limit_color = "warning"
	elseif (self.particle_manager.soft_limit >= 2048) then
		soft_limit_color = "notice"
	end

	self.debug_panel:line("particle manager", "soft limit", soft_limit_color, self.particle_manager.soft_limit)

	local hard_limit_color = "normal"

	if (self.particle_manager.hard_limit >= 8192) then
		hard_limit_color = "error"
	elseif (self.particle_manager.hard_limit >= 4096) then
		hard_limit_color = "warning"
	elseif (self.particle_manager.hard_limit >= 2048) then
		hard_limit_color = "notice"
	end

	self.debug_panel:line("particle manager", "hard limit", hard_limit_color, self.particle_manager.hard_limit)

	self.debug_panel:line("simulation", "frametime", "normal", math.round(self.simulation.frametime, 4))
	self.debug_panel:line("simulation", "delta", "normal", math.round(self.simulation.delta, 4))
	self.debug_panel:line("simulation", "frame", "normal", self.simulation.frame)
	self.debug_panel:line("simulation", "fps", "normal", self.simulation.fps())
	self.debug_panel:line("simulation", "vischeck interval", "normal", self.simulation.vischeck_interval)

	for _, hook in pairs(self.hook_manager.hooks) do
		self.debug_panel:line("hook manager", hook.name, "normal", string.format(
			"%s total | %s alive",
			hook.total_spawned,
			hook.total_alive
		))
	end
end
--endregion

--region setup
-- Main Illusion instance.
local illusion = illusion_c.new()
--endregion

--region illusion_wrapper
--- @class illusion_wrapper_c
--- @field public hook illusion_hook_c Illusion wrapper's hook.
--- @field public timer_standard timer_standard_c Illusion timer standard.
--- @field public timer_tick timer_tick_c Illusion timer tick.
--- @field public timer_countdown timer_countdown_c Illusion timer countdown.
--- @field public vector fun(x: number, y: number, z: number): vector_old_c Illusion vector function.
--- @field public angle fun(p: number, y: number, r: number): angle_old_c Illusion angle function.
--- @field public shader shader_c Illusion shader.
--- @field public animator illusion_animator_c Illusion animator helper.
--- @field public shared illusion_shared_c Illusion shared properties.
--- @field public simulation illusion_simulation_c Illusion simulation properties.
local illusion_wrapper_c = {}
local illusion_wrapper_mt = { __index = illusion_wrapper_c }

--- Instantiate an object of illusion_wrapper_c.
--- @param hook illusion_hook_c
--- @return illusion_wrapper_c
function illusion_wrapper_c.new(hook)
	return setmetatable({
		hook = hook,
		timer_standard = timer.standard,
		timer_tick = timer.tick,
		timer_countdown_c = timer.countdown,
		callbacks = callbacks,
		vector = vectorh,
		angle = angle,
		shader = shader_c,
		animator = illusion_animator,
		shared = illusion.shared,
		simulation = illusion.simulation
	}, illusion_wrapper_mt)
end

--- Create a particle.
--- @return illusion_particle_c|nil
function illusion_wrapper_c:create()
	-- Particle ID.
	local particle_id = illusion.particle_manager.total_spawned + 1

	-- Create the particle.
	local particle = illusion_particle_c.new(particle_id, illusion.shared, illusion.simulation, self.hook)

	-- Add the particle to the particle manager and hook.
	illusion.particle_manager:add(particle)

	return particle
end

--- Removes all particles.
--- @return void
function illusion_wrapper_c:wipe()
	for _, particle in pairs(self.hook.particles) do
		self.hook:remove(particle)
		illusion.particle_manager:remove(particle)
	end
end

--- Returns true if Illusion is available for use.
--- @return boolean
function illusion_wrapper_c:available()
	return illusion.state:available()
end

--- Set the on_tick interval for particles in seconds.
--- @param interval number
--- @return void
function illusion_wrapper_c:set_tick_interval(interval)
	self.hook.tick_interval = interval
end
--endregion

--- @param hook_name string
--- @return illusion_wrapper_c
local create_hook = function(hook_name)
	local hook = illusion.hook_manager:create(hook_name)

	return illusion_wrapper_c.new(hook)
end
--endregion

callbacks.push("on_paint", function()
	-- Illusion is in panic mode.
	if (illusion.panic:test(illusion.console, illusion.state) == false) then
		return
	end

	-- Begin panic test.
	illusion.panic:start()

	-- Process current engine frame.
	illusion:process()

	-- Complete panic test.
	illusion.panic:stop()
end)

--region decay field
local illusion_hook_decay = create_hook("decay field")

--region menu
ui.add_checkbox("Enable Decay Field")
ui.add_colorpicker("Field accent")

ui.add_sliderint("Field spawn rate", 10, 100)
ui.add_sliderint("Field speed", 1, 20)
ui.add_sliderint("Field radius", 1, 50)

local field_shader = illusion_hook_decay.shader.rgb(255, 255, 255, 255)
--endregion

--region main
callbacks.push("on_paint", function()
	if (ui.get_bool("Enable Decay Field") == false or illusion_hook_decay:available() == false or illusion_hook_decay.shared.is_dead == true) then
		return
	end

	local field_shader_color = ui.get_color("Field accent")

	field_shader:set_r(field_shader_color:r())
	field_shader:set_g(field_shader_color:g())
	field_shader:set_b(field_shader_color:b())
	field_shader:set_a(field_shader_color:a())

	local spawn_rate_value = ui.get_int("Field spawn rate")
	local field_speed_value = ui.get_int("Field speed") * 0.1
	local field_radius_value = ui.get_int("Field radius") * 0.1

	if (math.random(0, 100) > spawn_rate_value) then
		return
	end

	if (illusion_hook_decay.shared.player_speed < math.floor(math.random(0, 450))) then
		return
	end

	local spawn_vector = illusion_hook_decay.shared.player_origin:clone_offset(
		math.floor(math.random(-16, 16)),
		math.floor(math.random(-16, 16)),
		math.floor(math.random(0, 64))
	)

	local decay = illusion_hook_decay:create()

	decay.origin = spawn_vector
	decay.shader = field_shader:clone()
	decay.type = "circle"
	decay.radius = field_radius_value
	decay.timer = illusion_hook_decay.timer_standard(true)
	decay.fade_time = 0.5
	decay.target_vector = illusion_hook_decay.vector(0, 0, 0.33)
	decay.on_frame = function()
		decay:kill_invisible()

		decay.shader:fade_out(1 * illusion_hook_decay.simulation.delta)
		decay.shader:desaturate(0.0025 * illusion_hook_decay.simulation.delta)

		decay.timer:event(0.33, function()
			decay.target_vector(
				math.random_float(-0.33, 0.33),
				math.random_float(-0.33, 0.33),
				math.random_float(0.1, 0.25)
			)

			decay.timer:restart()
		end)

		decay.origin = decay.origin + decay.target_vector * field_speed_value * illusion_hook_decay.simulation.delta
	end
end)
--endregion
--endregion