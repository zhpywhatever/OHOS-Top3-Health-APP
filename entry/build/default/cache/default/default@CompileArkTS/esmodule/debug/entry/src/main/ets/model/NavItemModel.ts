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
export interface NavItem {
    icon: Resource;
    icon_selected: Resource;
    text: Resource;
    id: number;
}
// tabId
export enum TabId {
    HOME = 0,
    ACHIEVEMENT = 1,
    MINE = 2
}
export const NavList: NavItem[] = [
    {
        icon: { "id": 16777384, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" },
        icon_selected: { "id": 16777385, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" },
        text: { "id": 16777253, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" },
        id: TabId.HOME
    },
    {
        icon: { "id": 16777382, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" },
        icon_selected: { "id": 16777383, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" },
        text: { "id": 16777252, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" },
        id: TabId.ACHIEVEMENT
    },
    {
        icon: { "id": 16777386, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" },
        icon_selected: { "id": 16777387, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" },
        text: { "id": 16777254, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" },
        id: TabId.MINE
    },
];
