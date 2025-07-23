var Module;
var SDK_version = "latest";
var moduleLoaded;
function getBaseURL() {
	var originURL = window.location.origin;
	if (originURL.localeCompare("https://new.magiclane.com") === 0)
		return originURL + "/";
	else
	if (originURL.localeCompare("https://internal.magiclane.com") === 0)
		return originURL + "/";
	else
	if (originURL.localeCompare("https://developer.magiclane.com") === 0)
		return originURL + "/";
	else
	if (originURL.localeCompare("https://new.generalmagic.com") === 0)
		return originURL + "/";
	else
	if (originURL.localeCompare("https://internal.generalmagic.com") === 0)
		return originURL + "/";
	else
	if (originURL.localeCompare("https://developer.generalmagic.com") === 0)
		return originURL + "/";
	return "https://www.magiclane.com/";
}


var baseURL = getBaseURL();
var sourceWebsite = "assets/packages/gem_kit/assets/";
function preRunStatic(worldMapFileI) {

    let baseURI = baseURL + "sdk/js/";
    let worldMapFile = baseURI + worldMapFileI;
    const searchString = window.location.search;
    const urlParams = new URLSearchParams(searchString);
    if (urlParams.has("app_key")) { 
    }
   
    var n = worldMapFile.lastIndexOf("/");
    var filename = worldMapFile.substring(n);
    Module.noImageDecoding = true;
    FS.createPath('/', 'Data', true, true);
    FS.createPath('/Data', 'Res', true, true);
    FS.createPath('/Data/Res', 'Obj', true, true);
    FS.createPath('/Data/Res', 'Renderer', true, true);
    FS.createPath('/Data/Res', 'Weather', true, true);
    FS.createPath('/Data', 'SceneRes', true, true);
   
    try {
       FS.createPreloadedFile("/Data/Res", filename, baseURI + "res/map/latest/", true, true);
       FS.createPreloadedFile("/Data/SceneRes", 'Basic_1-1_1_1.style', baseURI + 'Basic_1-1_1_1.style', true, true);


       FS.createPreloadedFile("/Data/Res", 'Countries.proto', baseURI + 'res/lang/generic/Countries.proto', true, true);
       FS.createPreloadedFile("/Data/Res", 'Icon.db', baseURI + 'res/icon/SDL/Icon.db', true, true);
       FS.createPreloadedFile("/Data/Res", 'Ipa_Lhp.pst', baseURI + 'AppData/Data/Res/Ipa_Lhp.pst', true, true);
       FS.createPreloadedFile("/Data/Res", 'Ipa_XSampa.pst', baseURI + 'AppData/Data/Res/Ipa_XSampa.pst', true, true);
       FS.createPreloadedFile("/Data/Res", 'MapScheme.proto', baseURI + 'res/lang/generic/MapScheme.proto', true, true);
       FS.createPreloadedFile("/Data/Res", 'Traffic.proto', baseURI + 'res/lang/generic/Traffic.proto', true, true);

       FS.createPreloadedFile("/Data/Res", 'Translations.proto', baseURI + 'res/lang/Controller/Translations.proto', true, true);

       FS.createPreloadedFile("/Data/Res", 'Weather.proto', baseURI + 'res/lang/generic/Weather.proto', true, true);
       FS.createPreloadedFile("/Data/Res/Obj", 'arrow.obj', baseURI + 'AppData/Data/Res/Obj/arrow.obj', true, true);

       FS.createPreloadedFile("/Data/Res/Renderer", 'Font-2.sys', baseURI + 'AppData/Data/Res/Renderer/Font-2.sys', true, true);
       FS.createPreloadedFile("/Data/Res/Renderer", 'Font-Arabic.sys', baseURI + 'AppData/Data/Res/Renderer/Font-Arabic.sys', true, true);
       FS.createPreloadedFile("/Data/Res/Renderer", 'Font-Bold2.sys', baseURI + 'AppData/Data/Res/Renderer/Font-Bold2.sys', true, true);
       FS.createPreloadedFile("/Data/Res/Renderer", 'Font-Cambodian.sys', baseURI + 'AppData/Data/Res/Renderer/Font-Cambodian.sys', true, true);
       FS.createPreloadedFile("/Data/Res/Renderer", 'Font-Italic2.sys', baseURI + 'AppData/Data/Res/Renderer/Font-Italic2.sys', true, true);
       FS.createPreloadedFile("/Data/Res/Renderer", 'Font-Myanmar.sys', baseURI + 'AppData/Data/Res/Renderer/Font-Myanmar.sys', true, true);
       FS.createPreloadedFile("/Data/Res/Renderer", 'Fonts2.chf', baseURI + 'AppData/Data/Res/Renderer/Fonts2.chf', true, true);
       FS.createPreloadedFile("/Data/Res/Renderer", 'Font-Ethiopia.sys', baseURI + 'AppData/Data/Res/Renderer/Font-Ethiopia.sys', true, true);				
       FS.createPreloadedFile("/Data/Res/Weather", 'atmos.bmp', baseURI + 'AppData/Data/Res/Weather/atmos.bmp', true, true);
       FS.createPreloadedFile("/Data/Res/Weather", 'colorpallet.tga', baseURI + 'AppData/Data/Res/Weather/colorpallet.tga', true, true);
       FS.createPreloadedFile("/Data/Res/Weather", 'radar_colorpalette.tga', baseURI + 'AppData/Data/Res/Weather/radar_colorpalette.tga', true, true);
       FS.createPreloadedFile("/Data/Res/Weather", 'SunFlare.dat', baseURI + 'AppData/Data/Res/Weather/SunFlare.dat', true, true);
       FS.createPreloadedFile("/Data/Res/Weather", 'greyscale_colorbar.bmp', baseURI + 'AppData/Data/Res/Weather/greyscale_colorbar.bmp', true, true);
    } catch (error) {

    }
}
function addScriptToDom(scriptCode) {
    return new Promise(function (resolve, reject) {
        var script = document.createElement('script');
        var blob = new Blob([scriptCode], {
            type: 'application/javascript'
        });
        var objectUrl = URL.createObjectURL(blob);
        script.src = objectUrl;
        script.onload = function () {
            script.onload = script.onerror = null; // Remove these onload and onerror handlers, because these capture the inputs to the Promise and the input function, which would leak a lot of memory!
            URL.revokeObjectURL(objectUrl); // Free up the blob. Note that for debugging purposes, this can be useful to comment out to be able to read the sources in debugger.
            resolve();
        }
        script.onerror = function (e) {
            script.onload = script.onerror = null; // Remove these onload and onerror handlers, because these capture the inputs to the Promise and the input function, which would leak a lot of memory!
            URL.revokeObjectURL(objectUrl);
            console.error('script failed to add to dom: ' + e);
            reject(e.message || "(out of memory?)");
        }
        document.body.appendChild(script);
    });
}
function initApp()
{
Module = {
    preRun: [],
    postRun: [],
    print: (function () {
        return function (text) {
            text = Array.prototype.slice.call(arguments).join(' ');
            console.log(text);
        };
    })(),
    printErr: function (text) {
        text = Array.prototype.slice.call(arguments).join(' ');
        console.error(text);
    },
    canvas: (function () {
        var canvas = document.getElementById('canvas');
        return canvas;
    })(),
};

try {
    Module['preRun'].push(function () {
        preRunStatic('WM_7_403.map');
        Module.useperisistentstorage = 0;
    });
    Module['postRun'].push(function () {
     
        var canvas = document.getElementById('canvas');
        if(finishedLoadWasm)
        {
            finishedLoadWasm();
        }
        //var wrapper = document.getElementById('wrapper');
        //if (wrapper !== null && wrapper !== undefined)
        //    wrapper.remove();
        //canvas.style.visibility = 'visible';
        if (!Module.useperisistentstorage) {
            //if (parseInt(canvas.style.width) < 1 || parseInt(canvas.style.height) < 1) {
            //    console.warn("Please use a valid canvas width & height");
              
           // } else {
              
           // }
            window.addEventListener("beforeunload", e => {
            
            }, {
                once: true
            });
        }
    });
}catch(e)
{

}
fetch('assets/packages/gem_kit/assets/FlutterPluginWASM.js').then((response) => response.arrayBuffer())
.then((bytes) => {
    Module['javscriptFile'] = bytes;
    addScriptToDom(bytes);
});

}

window.callHeapU8Subarray = function(imgBufferPtr, imgBufferSize) {
    if (typeof Module !== 'undefined' && Module.HEAPU8) {
      return Module.HEAPU8.subarray(imgBufferPtr, imgBufferPtr + imgBufferSize);
    } else {
      console.error("Module or HEAPU8 is not available.");
      return null;
    }
  };

  window.callCreateImage = function(uint8Array,imgType) {
    if (typeof Module !== 'undefined') {
      const bufferSize = uint8Array.length;
      
      // Allocate memory in WebAssembly for the Uint8List
      const wasmPtr = Module._gemAlloc(bufferSize);
      
      if (wasmPtr === 0) {
        console.error('Failed to allocate memory in WebAssembly.');
        return null;
      }
      
      // Copy the Uint8List data to WebAssembly memory (HEAPU8 is a view on WebAssembly memory)
      Module.HEAPU8.set(uint8Array, wasmPtr);
      
      // Call a WebAssembly function and pass the pointer
      let result = Module._createGemImage(wasmPtr, bufferSize,imgType);
      
      // Free the allocated memory in WebAssembly once done (optional, if you know when)
      Module._gemFree(wasmPtr);
      
      return result;  // Optionally return the pointer if needed
    } else {
      console.error('Module or HEAPU8 is not available.');
      return null;
    }
  };
  window.passBinaryDataToWasm = function passBinaryDataToWasm(binaryData) {
    if (typeof Module !== 'undefined') {
      const length = binaryData.length;
      
      // Allocate memory in WebAssembly for the binary data
      const dataPointer = Module._gemAlloc(length);
      
      if (dataPointer === 0) {
        console.error('Failed to allocate memory in WebAssembly.');
        return null;
      }
      
      // Copy the Uint8List data to WebAssembly memory (binaryData is assumed to be a Uint8Array)
      Module.HEAPU8.set(binaryData, dataPointer);
      
      // Return the pointer to the allocated memory
      return dataPointer;
    } else {
      console.error('Module or HEAPU8 is not available.');
      return null;
    }
  }

  window.registerWeakPtr = function registerWeakPtr(pointerId)
  {
    return new Module.AutoReleaseObject(pointerId);
  }
