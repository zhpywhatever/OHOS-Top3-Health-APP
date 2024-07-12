/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { IDataSource } from '../IDataSource'
import fileio from '@ohos.fileio'
import Url from '@ohos.url'
import uri from '@ohos.uri'
import request from '@ohos.request';
import {GlobalContext} from '../../../../../../../GlobalContext'

export class JSONSource implements IDataSource<[]> {
  private mJSONArray: []|ESObject = [];
  private mInput: fileio.Stream|ESObject = null;
  public DOWNLOAD_FILE_PATH = GlobalContext.getContext().getValue("path").toString() + '/danmuku.xml'
  public MAX_BUFFER_SIZE = 1024 * 1024

  constructor(json: string | fileio.Stream | Url.URL | uri.URI) {
    if (json instanceof Url.URL || json instanceof uri.URI) {
      this.initFromURL(json)
    } else {
      this.init(json)
    }
  }

  private initFromURL(filePath: Url.URL | uri.URI) {
    let ctx = getContext(this);
    let downloadTask:ESObject;
    let that = this
    request.downloadFile(ctx, { url: filePath.toString(),
      filePath: this.DOWNLOAD_FILE_PATH }, (err, data) => {
      if (err) {
        console.error('Failed to request the download. Cause: ' + JSON.stringify(err));
        return;
      }
      downloadTask = data;
      downloadTask.on('complete', ()=> {
        fileio.createStream(this.DOWNLOAD_FILE_PATH, "r+",  (err, stream)=> {
          if (err) {
            console.error('Failed to createStream. Cause: ' + JSON.stringify(err));
            return
          }
          that.mInput = stream
          let fileSize = fileio.statSync(this.DOWNLOAD_FILE_PATH).size;
          if (fileSize >this.MAX_BUFFER_SIZE) {
            throw new Error('danmaku jsonSource initFromURL failed cause：this file is oversize 1M')
          }
          that.mInput.read(new ArrayBuffer(fileSize),).then((readOut:ESObject)=> {
            let dataString:ESObject = String.fromCharCode(...new Uint8Array(readOut.buffer))
            that.mJSONArray = dataString != null ? JSON.parse(dataString) : []
          })
        });
      }
      );
    });

  }

  private init(json: string | fileio.Stream) {
    if (typeof json === 'string') {
      if (json != null || json != undefined || (json as ESObject).length != 0) {
        this.mJSONArray = JSON.parse(json)
      }
    } else {
      if (json != null) {
        let that = this
        this.mInput = json
        this.mInput.read(new ArrayBuffer(this.MAX_BUFFER_SIZE),).then((readOut:ESObject)=> {
          let dataString:ESObject = String.fromCharCode(...new Uint8Array(readOut.buffer))
          that.mJSONArray = dataString != null ? JSON.parse(dataString) : []
        })
      }
    }
  }

  public release() {
    if (this.mInput != null) {
      this.mInput.close()
    }
    this.mInput = null;
    this.mJSONArray = null;
  }

  public data():ESObject {
    return this.mJSONArray
  }
}