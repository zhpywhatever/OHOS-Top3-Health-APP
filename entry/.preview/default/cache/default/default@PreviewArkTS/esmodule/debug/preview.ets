struct preview{build(){List({ space: Const.LIST_ITEM_SPACE }) {
          ListItem() {
            TaskChooseItem()
          }
          .listItemStyle()

          ListItem() {
            TargetSetItem()
              .enabled(
                this.settingParams?.isOpen
                  && this.settingParams?.taskID !== taskType.smile
                  && this.settingParams?.taskID !== taskType.brushTeeth
              )
              .onClick(() => {
                this.broadCast.emit(
                  BroadCastType.SHOW_TARGET_SETTING_DIALOG);
              })
          }
          .listItemStyle()
          .onClick(() => {
            if (!this.settingParams.isOpen)
              promptAction.showToast({
                message: '请先开启任务'
              });
          })

          ListItem() {
            OpenRemindItem()
              .enabled(this.settingParams?.isOpen)
          }
          .listItemStyle()
          .onClick(() => {
            if (!this.settingParams.isOpen)
              promptAction.showToast({
                message: '请先开启任务'
              });
          })

          ListItem() {
            RemindTimeItem()
              .enabled(this.settingParams?.isOpen && this.settingParams?.isAlarm)
              .onClick(() => {
                this.broadCast.emit(BroadCastType.SHOW_REMIND_TIME_DIALOG);
              })
          }
          .listItemStyle()
          .onClick(() => {
            if (!this.settingParams.isOpen)
              promptAction.showToast({
                message: '请先开启任务'
              }); else if (!this.settingParams.isAlarm)
              promptAction.showToast({
                message: '请先开启提醒'
              });
          })

          ListItem() {
            FrequencyItem()
              .enabled(this.settingParams?.isOpen && this.settingParams?.isAlarm)
              .onClick(() => {
                this.broadCast.emit(BroadCastType.SHOW_FREQUENCY_DIALOG);
              })
          }
          .listItemStyle()
          .onClick(() => {
            if (!this.settingParams.isOpen)
              promptAction.showToast({
                message: '请先开启任务'
              }); else if (!this.settingParams.isAlarm)
              promptAction.showToast({
                message: '请先开启提醒'
              });
          })
        }
        // .height(Const.THOUSANDTH_500)
        .width(Const.THOUSANDTH_940)}}