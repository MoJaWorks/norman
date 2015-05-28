#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "Utils.h"


using namespace accelerometer;



static value accelerometer_sample_method (value inputValue) {
	
	int returnValue = SampleMethod(val_int(inputValue));
	return alloc_int(returnValue);
	
}
DEFINE_PRIM (accelerometer_sample_method, 1);



extern "C" void accelerometer_main () {
	
	val_int(0); // Fix Neko init
	
}
DEFINE_ENTRY_POINT (accelerometer_main);



extern "C" int accelerometer_register_prims () { return 0; }