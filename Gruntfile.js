

module.exports = function(grunt) {

  grunt.loadNpmTasks("grunt-aws");

  grunt.initConfig({

    aws: grunt.file.readJSON("secrets.json"),

    s3: {
      options: {
        accessKeyId: "<%= aws.S3_KEY%>",
        secretAccessKey: "<%= aws.S3_SECRET %>",
        bucket: "<%= aws.S3_BUCKET %>",
        gzip: false
      },

      build: {
        cwd: "tilemill/images/",
        src: "**",
        dest: 'stamen-base/'
      }
    },

  });

  grunt.registerTask("default", ["s3"]);

};

