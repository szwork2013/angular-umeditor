#define ['angular'], (angular)->
  angular.module('ng-umeditor', [])
  .directive 'ngUmeditor', ->
    return {
      restrict: 'A'
      require: '?ngModel'
      socpe: {}
      link: (scope, element, attrs, ngModel)->
        if ngModel is null
          throw Error 'ngModel be require'
          return null
        editor = UM.getEditor(element[0])

        ngModel.$render ->
          editor.ready ->
            editor.setContent(ngModel.$viewValue || '')

        editor.addListener 'selectionchange', ->
          scope.$apply ->
            ngModel.$setViewValue(editor.getContent())

    }