import template from './edit-group-dialog.html';

const EditGroupDialogComponent = {
  template,
  bindings: {
    resolve: '<',
    close: '&',
    dismiss: '&',
  },
  controller($location) {
    'ngInject';

    this.group = this.resolve.group;
    const newGroup = this.group.id === undefined;

    if (newGroup) {
      this.saveButtonText = '添加';
      this.title = '添加群组';
    } else {
      this.saveButtonText = '保存';
      this.title = '编辑群组';
    }

    this.ok = () => {
      this.group.$save((group) => {
        if (newGroup) {
          $location.path(`/groups/${group.id}`).replace();
          this.close();
        } else {
          this.close();
        }
      });
    };
  },
};

export default function (ngModule) {
  ngModule.component('editGroupDialog', EditGroupDialogComponent);
}
