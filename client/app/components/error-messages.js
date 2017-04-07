const ErrorMessagesComponent = {
  template: `
  <div class="help-block" ng-messages="$ctrl.input.$error" ng-show="$ctrl.input.$touched || $ctrl.form.$submitted">
    <span class="error" ng-message="required">此字段必填.</span>
    <span class="error" ng-message="minlength">这个字段长度不够</span>
    <span class="error" ng-message="email">这需要是一个有效的电子邮件</span>
  </div>
  `,
  replace: true,
  bindings: {
    input: '<',
    form: '<',
  },
  controller() {
  },
};

export default function (ngModule) {
  ngModule.component('errorMessages', ErrorMessagesComponent);
}
