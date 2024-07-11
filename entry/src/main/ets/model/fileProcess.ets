// WriteFile.ets
import { fileIo } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { buffer } from '@kit.ArkTS';

let context = getContext(this) as common.UIAbilityContext;
let filesDir = context.filesDir + '/';

function ensureFileExists(filename: string): void {
  let filePath = filename;
  if (!fileIo.accessSync(filePath)) {
    let fileStream = fileIo.createStreamSync(filename, "w");
    fileStream.close();
  }
}

export function writeFile(filename: string, content: string): void {
  let filePath = filesDir + filename;
  ensureFileExists(filePath);
  let fileStream = fileIo.createStreamSync(filePath, "w");
  fileStream.writeSync(content);
  fileStream.close();
}

let res: string = '';
export function readFile(filename: string): string {
  let filePath = filesDir + filename;
  ensureFileExists(filePath);

  let stat = fileIo.statSync(filePath);
  let size = stat.size;
  let buf = new ArrayBuffer(size);
  let fileStream = fileIo.createStreamSync(filePath, "r+");
  // 基于文件流读取信息
  fileStream.readSync(buf);
  // 将读取的信息转换为字符串类型，并返回字符串类型。
  let con = buffer.from(buf, 0);
  res = con.toString();
  fileStream.close();
  return res;
}