const select2_setting_list = {
  theme: "bootstrap-5",
  language: "ja",
  multiple: true,
  tokenSeparators: [',', ' '],
  minimumInputLength: 1,
  ajax: {
    url: "/tags",
    dataType: 'json',
    delay: 250,
    data: (params) => {
      return {
        name: params.term
      };
    },
    processResults: (data, params) => {
      var result = data.map(tag => {
        return {id: tag.id, text: tag.name}
      })
      return {
        results: result
      };
    },
    cache: true
  }
}
