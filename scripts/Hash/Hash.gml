/// GMS 2.3.0 Hash
/// @author Simone Guerra <Homunculus>

function Hash() constructor {
	
	// Applies the result of a function to every value
	static apply = function(f) {
		var i = iterator();
		
		for(var j = 0; i.next(); j++) {
			var key = i.get_key();
			set(key, f(key, i.get_val(), j));
		}
		
		delete i;
	};
	
	// Clears all values and keys
	static clear = function() {
		_data = {};
		_size = 0;
	};
	
	// Iterates over the hashmap and invoke a function for each key / value pair
	static each = function(f) {
		var i = iterator();
		
		for(var j = 0; i.next(); j++) {
			if(f(i.get_key(), i.get_val(), j) != 0) { break; }
		}
		
		delete i;
	};
	
	// Checks if a key exists in the hashmap
	static exists = function(key) {
		return !is_undefined(variable_struct_get(_data, key));
	};
	
	// Gets the value for the specified key	
	static get = function(key) {
		var val = variable_struct_get(_data, key);
		return is_undefined(val) ? undefined : val[0];
	};
	
	// Get key as an array
	static keys = function() {
		var collection = array_create(_size);
		var i = iterator();
		
		for(var j = 0; i.next(); j++) {
			collection[j] = i.get_key();
		}
		
		delete i;
		return collection;
	};
	
	// Creates a new iterator for the hashmap
	static iterator = function() {
		return new Iterator(self);
	};
	
	// Creates a collection of values returned from invoking a function over every key / value pair
	static map = function(f) {
		var collection = array_create(_size);
		var i = iterator();
		
		for(var j = 0; i.next(); j++) {
			collection[j] = f(i.get_key(), i.get_val(), j);
		}
		
		delete i;
		return collection;
	};
	
	// Outputs the hashmap contents to the console
	static print = function() {
		show_debug_message("#!HashMap!# Size: " + string(_size));
		var i = iterator();
		while(i.next()) {
			var key = i.get_key();
			var val = i.get_val();
			show_debug_message(" -> [" + string(key) + ": " + string(val) + "]");
		};
		delete i;
	};
	
	// Removes a value from the map
	static remove = function(key) {
		if(exists(key)) { 
			variable_struct_set(_data, key, undefined);
			_size--;
		}
	};

	// Sets a value, creating a new one or replacing an existing one
	static set = function(key, val) {
		if(!exists(key)) { _size++; }
		variable_struct_set(_data, key, [val]);
	};

	// Gets the number of entries
	static size = function() {
		return _size;
	};
	
	// Get every value as an array
	static values = function() {
		var collection = array_create(_size);
		var i = iterator();
		
		for(var j = 0; i.next(); j++) {
			collection[j] = i.get_val();
		}
		
		delete i;
		return collection;
	};
	
	/* PRIVATE */
	
	// Properties
	_data = {};
	_size = 0;
	
	// Iterator class
	static Iterator = function(map) constructor {
		_data = map._data;
		_size = map._size;
		_names = variable_struct_get_names(map._data);
		_index = 0;
		_count = 0;
		_key = undefined;
		_val = undefined;

		static next = function() {
			if(_count == _size) { return false; }
			
			do {
				var key = _names[_index++];
				var val = variable_struct_get(_data, key);
			} until(!is_undefined(val));
			
			_key = key;
			_val = val[0];
			_count++;
			return true;
		}
		
		static get_val = function() { return _val; }
		static get_key = function() { return _key; }
	};

}