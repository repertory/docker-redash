function controller($window, $location, toastr, currentUser) {
  this.canEdit = () => currentUser.isAdmin && this.group.type !== 'builtin';

  this.saveName = () => {
    this.group.$save();
  };

  this.deleteGroup = () => {
    if ($window.confirm('确定要删除该群组吗?')) {
      this.group.$delete(() => {
        $location.path('/groups').replace();
        toastr.success('删除成功');
      });
    }
  };
}

export default function (ngModule) {
  ngModule.component('groupName', {
    bindings: {
      group: '<',
    },
    transclude: true,
    template: `
      <h2 class="p-l-5">
        <edit-in-place editable="$ctrl.canEdit()" done="$ctrl.saveName" ignore-blanks='true' value="$ctrl.group.name"></edit-in-place>&nbsp;
        <button class="btn btn-xs btn-danger" ng-if="$ctrl.canEdit()" ng-click="$ctrl.deleteGroup()">删除</button>
      </h2>
    `,
    replace: true,
    controller,
  });
}
