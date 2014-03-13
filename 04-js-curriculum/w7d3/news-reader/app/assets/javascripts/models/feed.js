;(function(root){

  NewsReader.Models.Feed = Backbone.Model.extend({
    urlRoot: '/feeds/',

    parse: function(raw) {
      this.entries = new NewsReader.Collections.Entries(raw.entries)

      delete raw.entries;

      return raw;
    }
  });

})(this);

// ;(function(root){
//
//   NewsReader.Models.Feed = Backbone.Model.extend({
//     urlRoot: '/feeds/',
//
//     parse: function(raw) {
//       if (raw.entries) {
//         raw_entries = raw.entries.forEach(function(entry) {
//           entry.json = JSON.parse(entry.json);
//         });
//       } else { raw_entries = raw.entries }
//       this.entries = new NewsReader.Collections.Entries(raw_entries)
//       delete raw.entries;
//
//       return raw;
//     }
//   });
//
// })(this);