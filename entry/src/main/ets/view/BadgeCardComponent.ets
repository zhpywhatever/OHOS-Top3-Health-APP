/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { ratio2percent } from '../common/utils/Utils'
import { CommonConstants as Const } from '../common/constants/CommonConstants';

@Component
export struct BadgeCard {
  @Prop content: string = '';
  imgSrc: Resource = $r('app.string.empty');

  private getAchievementText(content: string): string {
    const achievementLevel = Number(content);
    switch (achievementLevel) {
      case 1:
        return '初出茅庐 - 打卡第 1 天';
      case 3:
        return '连续 3 天达成';
      case 7:
        return '连续 7 天达成';
      case 30:
        return '连续 30 天达成';
      case 50:
        return '连续 50 天达成';
      case 73:
        return '连续 73 天达成';
      case 99:
        return '连续 99 天达成';
      case 259:
        return '任务达人 - 累计完成 3 项任务';
      default:
        return `连续 ${achievementLevel} 天达成`;
    }
  }

  build() {
    Column({ space: Const.DEFAULT_18 }) {
      Image(this.imgSrc)
        .width(Const.FULL_WIDTH)
        .height(Const.ACHIEVE_CARD_IMG_HEIGHT)
        .objectFit(ImageFit.Contain)
      Text(this.getAchievementText(this.content))
        .lineHeight($r('app.float.default_16'))
        .fontSize($r('app.float.default_12'))
        .fontColor($r('app.color.white'))
    }
    .width(ratio2percent(Const.ACHIEVE_SPLIT_RATIO))
    .padding({ top: Const.ACHIEVE_CARD_TOP, bottom: Const.ACHIEVE_CARD_BOTTOM })
  }
}
