/*
 Copyright (c) 2012, Jason Sanford
 Google Vector Layers is a library for showing geometry objects
 from multiple geoweb services with the Google Maps API
*/
(function(a){a.gvector={VERSION:"1.3.0",noConflict:function(){a.gvector=this._originalgvector;return this},_originalgvector:a.gvector}})(this);/*
 Using portions of Leaflet code (https://github.com/CloudMade/Leaflet)
*/
gvector.Util={extend:function(a){for(var b=Array.prototype.slice.call(arguments,1),d=0,e=b.length,c;d<e;d++){c=b[d]||{};for(var f in c)c.hasOwnProperty(f)&&(a[f]=c[f])}return a},setOptions:function(a,b){a.options=gvector.Util.extend({},a.options,b)}};/*
 Using portions of Leaflet code (https://github.com/CloudMade/Leaflet)
*/
gvector.Class=function(){};
gvector.Class.extend=function(a){var b=function(){this.initialize&&this.initialize.apply(this,arguments)},d=function(){};d.prototype=this.prototype;d=new d;d.constructor=b;b.prototype=d;b.superclass=this.prototype;for(var e in this)this.hasOwnProperty(e)&&e!="prototype"&&e!="superclass"&&(b[e]=this[e]);a.statics&&(gvector.Util.extend(b,a.statics),delete a.statics);a.includes&&(gvector.Util.extend.apply(null,[d].concat(a.includes)),delete a.includes);if(a.options&&d.options)a.options=gvector.Util.extend({},
d.options,a.options);gvector.Util.extend(d,a);b.extend=arguments.callee;b.include=function(a){gvector.Util.extend(this.prototype,a)};return b};gvector.Layer=gvector.Class.extend({options:{fields:"",scaleRange:null,map:null,uniqueField:null,visibleAtScale:!0,dynamic:!1,autoUpdate:!1,autoUpdateInterval:null,infoWindowTemplate:null,singleInfoWindow:!1,symbology:null,showAll:!1},initialize:function(a){gvector.Util.setOptions(this,a)},setMap:function(a){if(!a||!this.options.map){if((this.options.map=a)&&this.options.scaleRange&&this.options.scaleRange instanceof Array&&this.options.scaleRange.length===2){var b=this.options.map.getZoom(),d=this.options.scaleRange;
this.options.visibleAtScale=b>=d[0]&&b<=d[1]}this[a?"_show":"_hide"]()}},getMap:function(){return this.options.map},setOptions:function(){},_show:function(){this._addIdleListener();this.options.scaleRange&&this.options.scaleRange instanceof Array&&this.options.scaleRange.length===2&&this._addZoomChangeListener();if(this.options.visibleAtScale){if(this.options.autoUpdate&&this.options.autoUpdateInterval){var a=this;this._autoUpdateInterval=setInterval(function(){a._getFeatures()},this.options.autoUpdateInterval)}google.maps.event.trigger(this.options.map,
"zoom_changed");google.maps.event.trigger(this.options.map,"idle")}},_hide:function(){this._idleListener&&google.maps.event.removeListener(this._idleListener);this._zoomChangeListener&&google.maps.event.removeListener(this._zoomChangeListener);this._autoUpdateInterval&&clearInterval(this._autoUpdateInterval);this._clearFeatures();this._lastQueriedBounds=null;if(this._gotAll)this._gotAll=!1},_hideVectors:function(){for(var a=0;a<this._vectors.length;a++){if(this._vectors[a].vector)if(this._vectors[a].vector.setMap(null),
this._vectors[a].infoWindow)this._vectors[a].infoWindow.close();else if(this.infoWindow&&this.infoWindow.get("associatedFeature")&&this.infoWindow.get("associatedFeature")==this._vectors[a])this.infoWindow.close(),this.infoWindow=null;if(this._vectors[a].vectors&&this._vectors[a].vectors.length)for(var b=0;b<this._vectors[a].vectors.length;b++)if(this._vectors[a].vectors[b].setMap(null),this._vectors[a].vectors[b].infoWindow)this._vectors[a].vectors[b].infoWindow.close();else if(this.infoWindow&&
this.infoWindow.get("associatedFeature")&&this.infoWindow.get("associatedFeature")==this._vectors[a])this.infoWindow.close(),this.infoWindow=null}},_showVectors:function(){for(var a=0;a<this._vectors.length;a++)if(this._vectors[a].vector&&this._vectors[a].vector.setMap(this.options.map),this._vectors[a].vectors&&this._vectors[a].vectors.length)for(var b=0;b<this._vectors[a].vectors.length;b++)this._vectors[a].vectors[b].setMap(this.options.map)},_clearFeatures:function(){this._hideVectors();this._vectors=
[]},_addZoomChangeListener:function(){var a=this;this._zoomChangeListener=google.maps.event.addListener(this.options.map,"zoom_changed",function(){a._checkLayerVisibility()})},_addIdleListener:function(){var a=this;this._idleListener=google.maps.event.addListener(this.options.map,"idle",function(){if(a.options.visibleAtScale)if(a.options.showAll){if(!a._gotAll)a._getFeatures(),a._gotAll=!0}else a._getFeatures()})},_checkLayerVisibility:function(){var a=this.options.visibleAtScale,b=this.options.map.getZoom(),
d=this.options.scaleRange;this.options.visibleAtScale=b>=d[0]&&b<=d[1];if(a!==this.options.visibleAtScale)this[this.options.visibleAtScale?"_showVectors":"_hideVectors"]();if(a&&!this.options.visibleAtScale&&this._autoUpdateInterval)clearInterval(this._autoUpdateInterval);else if(!a&&this.options.autoUpdate&&this.options.autoUpdateInterval){var e=this;this._autoUpdateInterval=setInterval(function(){e._getFeatures()},this.options.autoUpdateInterval)}},_setInfoWindowContent:function(a){var b=a.iwContent,
d;if(a.attributes)d=a.attributes;else if(a.properties)d=a.properties;else if(a.data)d=a.data;var e;if(typeof this.options.infoWindowTemplate=="string"){e=this.options.infoWindowTemplate;for(var c in d)e=e.replace(RegExp("{"+c+"}","g"),d[c])}else if(typeof this.options.infoWindowTemplate=="function")e=this.options.infoWindowTemplate(d);else return;a.iwContent=e;a.infoWindow?a.iwContent!=b&&a.infoWindow.setContent(a.iwContent):this.infoWindow&&this.infoWindow.get("associatedFeature")==a&&a.iwContent!=
b&&this.infoWindow.setContent(a.iwContent)},_showInfoWindow:function(a,b){var d={content:a.iwContent},e;if(this.options.singleInfoWindow){if(this.infoWindow)this.infoWindow.close(),this.infoWindow=null;this.infoWindow=new google.maps.InfoWindow(d);this.infoWindow.set("associatedFeature",a);e=this}else a.infoWindow=new google.maps.InfoWindow(d),e=a;var c=!1;if(a.vector){if(a.vector.getPaths||a.vector.getPath)c=!0}else if(a.vectors&&a.vectors.length&&(a.vectors[0].getPaths||a.vectors[0].getPath))c=
!0;var f=this;setTimeout(function(){e.infoWindow.open(f.options.map,c?new google.maps.Marker({position:b.latLng}):a.vector)},200)},_buildBoundsString:function(a){a=a.toUrlValue().split(",");return a[1]+","+a[0]+","+a[3]+","+a[2]},_getFeatureVectorOptions:function(a){var b={},a=a.attributes||a.properties;if(this.options.symbology)switch(this.options.symbology.type){case "single":for(var d in this.options.symbology.vectorOptions)b[d]=this.options.symbology.vectorOptions[d];break;case "unique":for(var e=
this.options.symbology.property,c=0,f=this.options.symbology.values.length;c<f;c++)if(a[e]==this.options.symbology.values[c].value)for(d in this.options.symbology.values[c].vectorOptions)b[d]=this.options.symbology.values[c].vectorOptions[d];break;case "range":e=this.options.symbology.property;c=0;for(f=this.options.symbology.ranges.length;c<f;c++)if(a[e]>=this.options.symbology.ranges[c].range[0]&&a[e]<=this.options.symbology.ranges[c].range[1])for(d in this.options.symbology.ranges[c].vectorOptions)b[d]=
this.options.symbology.ranges[c].vectorOptions[d]}return b},_getPropertiesChanged:function(a,b){var d=!1,e;for(e in a)a[e]!=b[e]&&(d=!0);return d},_getPropertyChanged:function(a,b,d){return a[d]!=b[d]},_getGeometryChanged:function(a,b){var d=!1;a.coordinates&&a.coordinates instanceof Array?a.coordinates[0]==b.coordinates[0]&&a.coordinates[1]==b.coordinates[1]||(d=!0):a.x==b.x&&a.y==b.y||(d=!0);return d},_makeJsonpRequest:function(a){var b=document.getElementsByTagName("head")[0],d=document.createElement("script");
d.type="text/javascript";d.src=a;b.appendChild(d)},_processFeatures:function(a){if(this.options.map){var b=this.options.map.getBounds();if(!this._lastQueriedBounds||!this._lastQueriedBounds.equals(b)||this.options.autoUpdate){this._lastQueriedBounds=b;this instanceof gvector.GeoIQ&&(a=JSON.parse(a));if(this instanceof gvector.PRWSF){a.features=a.rows;delete a.rows;for(var b=0,d=a.features.length;b<d;b++){a.features[b].type="Feature";a.features[b].properties={};for(var e in a.features[b].row)e=="geojson"?
a.features[b].geometry=a.features[b].row.geojson:a.features[b].properties[e]=a.features[b].row[e];delete a.features[b].row}}if(this instanceof gvector.GISCloud){a.features=a.data;delete a.data;b=0;for(d=a.features.length;b<d;b++)a.features[b].type="Feature",a.features[b].properties=a.features[b].data,a.features[b].properties.id=a.features[b].__id,delete a.features[b].data,a.features[b].geometry=a.features[b].__geometry,delete a.features[b].__geometry}if(a&&a.features&&a.features.length)for(b=0;b<
a.features.length;b++){if(this instanceof gvector.EsriJSONLayer)a.features[b].properties=a.features[b].attributes,delete a.features[b].attributes;e=!1;if(this.options.uniqueField)for(var c=0;c<this._vectors.length;c++)if(a.features[b].properties[this.options.uniqueField]==this._vectors[c].properties[this.options.uniqueField]&&(e=!0,this.options.dynamic)){if(this._getGeometryChanged(this._vectors[c].geometry,a.features[b].geometry)&&!isNaN(a.features[b].geometry.x||a.features[b].geometry.coordinates[0])&&
!isNaN(a.features[b].geometry.y||a.features[b].geometry.coordinates[1]))this._vectors[c].geometry=a.features[b].geometry,this._vectors[c].vector.setPosition(new google.maps.LatLng(a.features[b].geometry.y||this._vectors[c].geometry.coordinates[1],a.features[b].geometry.x||this._vectors[c].geometry.coordinates[0]));if(this._getPropertiesChanged(this._vectors[c].properties,a.features[b].properties)&&(d=this._getPropertyChanged(this._vectors[c].properties,a.features[b].properties,this.options.symbology.property),
this._vectors[c].properties=a.features[b].properties,this.options.infoWindowTemplate&&this._setInfoWindowContent(this._vectors[c]),this.options.symbology&&this.options.symbology.type!="single"&&d))if(this._vectors[c].vector)this._vectors[c].vector.setOptions(this._getFeatureVectorOptions(this._vectors[c]));else if(this._vectors[c].vectors)for(var f=0,d=this._vectors[c].vectors.length;f<d;f++)this._vectors[c].vectors[f].setOptions(this._getFeatureVectorOptions(this._vectors[c]))}if(!e||!this.options.uniqueField){this instanceof
gvector.GeoJSONLayer?(d=this._geoJsonGeometryToGoogle(a.features[b].geometry,this._getFeatureVectorOptions(a.features[b])),a.features[b][d instanceof Array?"vectors":"vector"]=d):this instanceof gvector.EsriJSONLayer&&(d=this._esriJsonGeometryToGoogle(a.features[b].geometry,this._getFeatureVectorOptions(a.features[b])),a.features[b][d instanceof Array?"vectors":"vector"]=d);if(a.features[b].vector)a.features[b].vector.setMap(this.options.map);else if(a.features[b].vectors&&a.features[b].vectors.length)for(f=
0;f<a.features[b].vectors.length;f++)a.features[b].vectors[f].setMap(this.options.map);this._vectors.push(a.features[b]);if(this.options.infoWindowTemplate){var g=this,d=a.features[b];this._setInfoWindowContent(d);(function(a){if(a.vector)google.maps.event.addListener(a.vector,"click",function(b){g._showInfoWindow(a,b)});else if(a.vectors)for(var b=0,c=a.vectors.length;b<c;b++)google.maps.event.addListener(a.vectors[b],"click",function(b){g._showInfoWindow(a,b)})})(d)}}}}}}});gvector.GeoJSONLayer=gvector.Layer.extend({_geoJsonGeometryToGoogle:function(a,b){var d,e;switch(a.type){case "Point":b.position=new google.maps.LatLng(a.coordinates[1],a.coordinates[0]);d=new google.maps.Marker(b);break;case "MultiPoint":e=[];for(var c=0,f=a.coordinates.length;c<f;c++)b.position=new google.maps.LatLng(a.coordinates[c][1],a.coordinates[c][0]),e.push(new google.maps.Marker(b));break;case "LineString":for(var g=[],c=0,f=a.coordinates.length;c<f;c++){var h=new google.maps.LatLng(a.coordinates[c][1],
a.coordinates[c][0]);g.push(h)}b.path=g;d=new google.maps.Polyline(b);break;case "MultiLineString":e=[];c=0;for(f=a.coordinates.length;c<f;c++){for(var g=[],i=0,j=a.coordinates[c].length;i<j;i++){var k=a.coordinates[c][i],h=new google.maps.LatLng(k[1],k[0]);g.push(h)}b.path=g;e.push(new google.maps.Polyline(b))}break;case "Polygon":k=[];c=0;for(f=a.coordinates.length;c<f;c++){g=[];i=0;for(j=a.coordinates[c].length;i<j;i++)h=new google.maps.LatLng(a.coordinates[c][i][1],a.coordinates[c][i][0]),g.push(h);
k.push(g)}b.paths=k;d=new google.maps.Polygon(b);break;case "MultiPolygon":e=[];c=0;for(f=a.coordinates.length;c<f;c++){k=[];i=0;for(j=a.coordinates[c].length;i<j;i++){for(var g=[],h=0,l=a.coordinates[c][i].length;h<l;h++)g.push(new google.maps.LatLng(a.coordinates[c][i][h][1],a.coordinates[c][i][h][0]));k.push(g)}b.paths=k;e.push(new google.maps.Polygon(b))}break;case "GeometryCollection":e=[];c=0;for(f=a.geometries.length;c<f;c++)e.push(this._geoJsonGeometryToGoogle(a.geometries[c],b))}return d||
e}});gvector.EsriJSONLayer=gvector.Layer.extend({_esriJsonGeometryToGoogle:function(a,b){var d,e;if(a.x&&a.y)b.position=new google.maps.LatLng(a.y,a.x),d=new google.maps.Marker(b);else if(a.points){e=[];for(var c=0,f=a.points.length;c<f;c++)b.position=new google.maps.LatLng(a.points[c].y,a.points[c].x),e.push(new google.maps.Marker(b))}else if(a.paths)if(a.paths.length>1){e=[];c=0;for(f=a.paths.length;c<f;c++){for(var g=[],h=0,i=a.paths[c].length;h<i;h++)g.push(new google.maps.LatLng(a.paths[c][h][1],
a.paths[c][h][0]));b.path=g;e.push(new google.maps.Polyline(b))}}else{g=[];c=0;for(f=a.paths[0].length;c<f;c++)g.push(new google.maps.LatLng(a.paths[0][c][1],a.paths[0][c][0]));b.path=g;d=new google.maps.Polyline(b)}else if(a.rings)if(a.rings.length>1){e=[];c=0;for(f=a.rings.length;c<f;c++){for(var j=[],g=[],h=0,i=a.rings[c].length;h<i;h++)g.push(new google.maps.LatLng(a.rings[c][h][1],a.rings[c][h][0]));j.push(g);b.paths=j;e.push(new google.maps.Polygon(b))}}else{j=[];g=[];c=0;for(f=a.rings[0].length;c<
f;c++)g.push(new google.maps.LatLng(a.rings[0][c][1],a.rings[0][c][0]));j.push(g);b.paths=j;d=new google.maps.Polygon(b)}return d||e}});gvector.AGS=gvector.EsriJSONLayer.extend({initialize:function(a){for(var b=0,d=this._requiredParams.length;b<d;b++)if(!a[this._requiredParams[b]])throw Error('No "'+this._requiredParams[b]+'" parameter found.');this._globalPointer="AGS_"+Math.floor(Math.random()*1E5);window[this._globalPointer]=this;a.url.substr(a.url.length-1,1)!=="/"&&(a.url+="/");this._originalOptions=gvector.Util.extend({},a);if(a.esriOptions)if(typeof a.esriOptions=="object")gvector.Util.extend(a,this._convertEsriOptions(a.esriOptions));
else{this._getEsriOptions();return}gvector.Layer.prototype.initialize.call(this,a);if(this.options.where)this.options.where=encodeURIComponent(this.options.where);this._vectors=[];if(this.options.map){if(this.options.scaleRange&&this.options.scaleRange instanceof Array&&this.options.scaleRange.length===2)a=this.options.map.getZoom(),b=this.options.scaleRange,this.options.visibleAtScale=a>=b[0]&&a<=b[1];this._show()}},options:{where:"1=1",url:null,useEsriOptions:!1},_requiredParams:["url"],_convertEsriOptions:function(a){var b=
{};if(!(a.minScale==void 0||a.maxScale==void 0)){var d=this._scaleToLevel(a.minScale),e=this._scaleToLevel(a.maxScale);e==0&&(e=20);b.scaleRange=[d,e]}if(a.drawingInfo&&a.drawingInfo.renderer)b.symbology=this._renderOptionsToSymbology(a.drawingInfo.renderer);return b},_getEsriOptions:function(){this._makeJsonpRequest(this._originalOptions.url+"?f=json&callback="+this._globalPointer+"._processEsriOptions")},_processEsriOptions:function(a){var b=this._originalOptions;b.esriOptions=a;this.initialize(b)},
_scaleToLevel:function(a){var b=[5.91657527591555E8,2.95828763795777E8,1.47914381897889E8,7.3957190948944E7,3.6978595474472E7,1.8489297737236E7,9244648.868618,4622324.434309,2311162.217155,1155581.108577,577790.554289,288895.277144,144447.638572,72223.819286,36111.909643,18055.954822,9027.977411,4513.988705,2256.994353,1128.497176,564.248588,282.124294];if(a==0)return 0;for(var d=0,e=0;e<b.length-1;e++){var c=b[e+1];if(a<=b[e]&&a>c){d=e;break}}return d},_renderOptionsToSymbology:function(a){symbology=
{};switch(a.type){case "simple":symbology.type="single";symbology.vectorOptions=this._parseSymbology(a.symbol);break;case "uniqueValue":symbology.type="unique";symbology.property=a.field1;for(var b=[],d=0;d<a.uniqueValueInfos.length;d++){var e=a.uniqueValueInfos[d],c={};c.value=e.value;c.vectorOptions=this._parseSymbology(e.symbol);c.label=e.label;b.push(c)}symbology.values=b;break;case "classBreaks":symbology.type="range";symbology.property=rend.field;b=[];e=a.minValue;for(d=0;d<a.classBreakInfos.length;d++){var c=
a.classBreakInfos[d],f={};f.range=[e,c.classMaxValue];e=c.classMaxValue;f.vectorOptions=this._parseSymbology(c.symbol);f.label=c.label;b.push(f)}symbology.ranges=b}return symbology},_parseSymbology:function(a){var b={};switch(a.type){case "esriSMS":case "esriPMS":b.icon=new google.maps.MarkerImage("data:"+a.contentType+";base64,"+a.imageData,null,null,new google.maps.Point(a.width/2,a.height/2));break;case "esriSLS":b.strokeWeight=a.width;b.strokeColor=this._parseColor(a.color);b.strokeOpacity=this._parseAlpha(a.color[3]);
break;case "esriSFS":a.outline?(b.strokeWeight=a.outline.width,b.strokeColor=this._parseColor(a.outline.color),b.strokeOpacity=this._parseAlpha(a.outline.color[3])):(b.strokeWeight=0,b.strokeColor="#000000",b.strokeOpacity=0),a.style!="esriSFSNull"?(b.fillColor=this._parseColor(a.color),b.fillOpacity=this._parseAlpha(a.color[3])):(b.fillColor="#000000",b.fillOpacity=0)}return b},_parseColor:function(a){red=this._normalize(a[0]);green=this._normalize(a[1]);blue=this._normalize(a[2]);return"#"+this._pad(red.toString(16))+
this._pad(green.toString(16))+this._pad(blue.toString(16))},_normalize:function(a){return a<1&&a>0?Math.floor(a*255):a},_pad:function(a){return a.length>1?a.toUpperCase():"0"+a.toUpperCase()},_parseAlpha:function(a){return a/255},_getFeatures:function(){this.options.uniqueField||this._clearFeatures();var a=this.options.url+"query?returnGeometry=true&outSR=4326&f=json&outFields="+this.options.fields+"&where="+this.options.where+"&callback="+this._globalPointer+"._processFeatures";this.options.showAll||
(a+="&inSR=4326&spatialRel=esriSpatialRelIntersects&geometryType=esriGeometryEnvelope&geometry="+this._buildBoundsString(this.options.map.getBounds()));this._makeJsonpRequest(a)}});gvector.A2E=gvector.AGS.extend({initialize:function(a){for(var b=0,d=this._requiredParams.length;b<d;b++)if(!a[this._requiredParams[b]])throw Error('No "'+this._requiredParams[b]+'" parameter found.');this._globalPointer="A2E_"+Math.floor(Math.random()*1E5);window[this._globalPointer]=this;a.url.substr(a.url.length-1,1)!=="/"&&(a.url+="/");this._originalOptions=gvector.Util.extend({},a);if(a.esriOptions)if(typeof a.esriOptions=="object")gvector.Util.extend(a,this._convertEsriOptions(a.esriOptions));
else{this._getEsriOptions();return}gvector.Layer.prototype.initialize.call(this,a);if(this.options.where)this.options.where=encodeURIComponent(this.options.where);this._vectors=[];if(this.options.map){if(this.options.scaleRange&&this.options.scaleRange instanceof Array&&this.options.scaleRange.length===2)a=this.options.map.getZoom(),b=this.options.scaleRange,this.options.visibleAtScale=a>=b[0]&&a<=b[1];this._show()}if(this.options.autoUpdate&&this.options.esriOptions.editFeedInfo){this._makeJsonpRequest("http://cdn.pubnub.com/pubnub-3.1.min.js");
var e=this;this._pubNubScriptLoaderInterval=setInterval(function(){window.PUBNUB&&e._pubNubScriptLoaded()},200)}},_pubNubScriptLoaded:function(){clearInterval(this._pubNubScriptLoaderInterval);this.pubNub=PUBNUB.init({subscribe_key:this.options.esriOptions.editFeedInfo.pubnubSubscribeKey,ssl:!1,origin:"pubsub.pubnub.com"});var a=this;this.pubNub.subscribe({channel:this.options.esriOptions.editFeedInfo.pubnubChannel,callback:function(){a._getFeatures()},error:function(){}})}});gvector.GeoIQ=gvector.GeoJSONLayer.extend({initialize:function(a){for(var b=0,d=this._requiredParams.length;b<d;b++)if(!a[this._requiredParams[b]])throw Error('No "'+this._requiredParams[b]+'" parameter found.');gvector.Layer.prototype.initialize.call(this,a);this._globalPointer="GeoIQ_"+Math.floor(Math.random()*1E5);window[this._globalPointer]=this;this._vectors=[];if(this.options.map){if(this.options.scaleRange&&this.options.scaleRange instanceof Array&&this.options.scaleRange.length===2)a=this.options.map.getZoom(),
b=this.options.scaleRange,this.options.visibleAtScale=a>=b[0]&&a<=b[1];this._show()}},options:{dataset:null},_requiredParams:["dataset"],_getFeatures:function(){this.options.uniqueField||this._clearFeatures();var a="http://geocommons.com/datasets/"+this.options.dataset+"/features.json?geojson=1&callback="+this._globalPointer+"._processFeatures&limit=999";this.options.showAll||(a+="&bbox="+this._buildBoundsString(this.options.map.getBounds())+"&intersect=full");this._makeJsonpRequest(a)}});gvector.CartoDB=gvector.GeoJSONLayer.extend({initialize:function(a){for(var b=0,d=this._requiredParams.length;b<d;b++)if(!a[this._requiredParams[b]])throw Error('No "'+this._requiredParams[b]+'" parameter found.');gvector.Layer.prototype.initialize.call(this,a);this._globalPointer="CartoDB_"+Math.floor(Math.random()*1E5);window[this._globalPointer]=this;this._vectors=[];if(this.options.map){if(this.options.scaleRange&&this.options.scaleRange instanceof Array&&this.options.scaleRange.length===2)a=
this.options.map.getZoom(),b=this.options.scaleRange,this.options.visibleAtScale=a>=b[0]&&a<=b[1];this._show()}},options:{version:1,user:null,table:null,fields:"*",where:null,limit:null,uniqueField:"cartodb_id"},_requiredParams:["user","table"],_getFeatures:function(){var a=this.options.where||"";if(!this.options.showAll)for(var b=this.options.map.getBounds(),d=b.getSouthWest(),b=b.getNorthEast(),e=this.options.table.split(",").length,c=0;c<e;c++)a+=(a.length?" AND ":"")+(e>1?this.options.table.split(",")[c].split(".")[0]+
".the_geom":"the_geom")+" && st_setsrid(st_makebox2d(st_point("+d.lng()+","+d.lat()+"),st_point("+b.lng()+","+b.lat()+")),4326)";this.options.limit&&(a+=(a.length?" ":"")+"limit "+this.options.limit);a=a.length?" "+a:"";this._makeJsonpRequest("http://"+this.options.user+".cartodb.com/api/v"+this.options.version+"/sql?q="+encodeURIComponent("SELECT "+this.options.fields+" FROM "+this.options.table+(a.length?" WHERE "+a:""))+"&format=geojson&callback="+this._globalPointer+"._processFeatures")}});gvector.PRWSF=gvector.GeoJSONLayer.extend({initialize:function(a){for(var b=0,d=this._requiredParams.length;b<d;b++)if(!a[this._requiredParams[b]])throw Error('No "'+this._requiredParams[b]+'" parameter found.');a.url.substr(a.url.length-1,1)!=="/"&&(a.url+="/");gvector.Layer.prototype.initialize.call(this,a);this._globalPointer="PRWSF_"+Math.floor(Math.random()*1E5);window[this._globalPointer]=this;this._vectors=[];if(this.options.map){if(this.options.scaleRange&&this.options.scaleRange instanceof
Array&&this.options.scaleRange.length===2)a=this.options.map.getZoom(),b=this.options.scaleRange,this.options.visibleAtScale=a>=b[0]&&a<=b[1];this._show()}},options:{geotable:null,srid:null,geomFieldName:"the_geom",fields:"",where:null,limit:null,uniqueField:null},_requiredParams:["url","geotable"],_getFeatures:function(){var a=this.options.where||"";if(!this.options.showAll){var b=this.options.map.getBounds(),d=b.getSouthWest(),b=b.getNorthEast();a+=a.length?" AND ":"";a+=this.options.srid?this.options.geomFieldName+
" && transform(st_setsrid(st_makebox2d(st_point("+d.lng()+","+d.lat()+"),st_point("+b.lng()+","+b.lat()+")),4326),"+this.options.srid+")":"transform("+this.options.geomFieldName+",4326) && st_setsrid(st_makebox2d(st_point("+d.lng()+","+d.lat()+"),st_point("+b.lng()+","+b.lat()+")),4326)"}this.options.limit&&(a+=(a.length?" ":"")+"limit "+this.options.limit);d=(this.options.fields.length?this.options.fields+",":"")+"st_asgeojson(transform("+this.options.geomFieldName+",4326)) as geojson";this._makeJsonpRequest(this.options.url+
"v1/ws_geo_attributequery.php?parameters="+encodeURIComponent(a)+"&geotable="+this.options.geotable+"&fields="+encodeURIComponent(d)+"&format=json&callback="+this._globalPointer+"._processFeatures")}});gvector.GISCloud=gvector.GeoJSONLayer.extend({initialize:function(a){for(var b=0,d=this._requiredParams.length;b<d;b++)if(!a[this._requiredParams[b]])throw Error('No "'+this._requiredParams[b]+'" parameter found.');gvector.Layer.prototype.initialize.call(this,a);this._globalPointer="GISCloud_"+Math.floor(Math.random()*1E5);window[this._globalPointer]=this;this._vectors=[];if(this.options.map){if(this.options.scaleRange&&this.options.scaleRange instanceof Array&&this.options.scaleRange.length===2)a=
this.options.map.getZoom(),b=this.options.scaleRange,this.options.visibleAtScale=a>=b[0]&&a<=b[1];this._show()}},options:{mapID:null,layerID:null,uniqueField:"id"},_requiredParams:["mapID","layerID"],_getFeatures:function(){var a="http://api.giscloud.com/1/maps/"+this.options.mapID+"/layers/"+this.options.layerID+"/features.json?geometry=geojson&epsg=4326&callback="+this._globalPointer+"._processFeatures";this.options.showAll||(a+="&bounds="+this._buildBoundsString(this.options.map.getBounds()));
this.options.where&&(a+="&where="+encodeURIComponent(this.options.where));this._makeJsonpRequest(a)}});