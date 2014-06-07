
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});


var Image = require("parse-image");
 
Parse.Cloud.beforeSave("VisitorsPhotos", function(request, response) {
  var visitorPhoto = request.object;
  if (!visitorPhoto.get("image")) {
    return;
  }
 
  if (!visitorPhoto.dirty("image")) {
    // The profile photo isn't being modified.
    response.success();
    return;
  }
 
  Parse.Cloud.httpRequest({
    url: visitorPhoto.get("image").url()
 
  }).then(function(response) {
    var image = new Image();
    return image.setData(response.buffer);
 
  }).then(function(image) {
    // Crop the image to the smaller of width or height.
    var size = Math.min(image.width(), image.height());
    return image.crop({
      left: (image.width() - size) / 2,
      top: (image.height() - size) / 2,
      width: size,
      height: size
    });
 
  }).then(function(image) {
    // Resize the image to 64x64.
    return image.scale({
      width: 64,
      height: 64
    });
 
  }).then(function(image) {
    // Make sure it's a JPEG to save disk space and bandwidth.
    return image.setFormat("JPEG");
 
  }).then(function(image) {
    // Get the image data in a Buffer.
    return image.data();
 
  }).then(function(buffer) {
    // Save the image into a new file.
    var base64 = buffer.toString("base64");
    var cropped = new Parse.File("thumbnail.jpg", { base64: base64 });
    return cropped.save();
 
  }).then(function(cropped) {
    // Attach the image file to the original object.
    visitorPhoto.set("imageThumbnail", cropped);
 
  }).then(function(result) {
    response.success();
  }, function(error) {
    response.error(error);
  });
});