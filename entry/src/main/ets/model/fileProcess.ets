// WriteFile.ets
import { fileIo } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { buffer } from '@kit.ArkTS';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

let context = getContext(this) as common.UIAbilityContext;
let filesDir = context.filesDir + '/';

export interface UserInfo {
  username: string;
  password: string;
  whatcanIsay?: string;
  // 可以添加其他用户信息字段
}

export function getAvatarPath(username: string) : string {
  return filesDir + username + "_avatar.png";
}

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

function writeJsonFile(filename: string, content: object): void {
  let filePath = filesDir + filename;
  ensureFileExists(filePath);
  let fileStream = fileIo.createStreamSync(filePath, "w");
  fileStream.writeSync(JSON.stringify(content));
  fileStream.close();
}

export function writeFilePlus(filename: string, content: string): void {
  let filePath = filesDir + filename;
  ensureFileExists(filePath);
  let fileStream = fileIo.createStreamSync(filePath, "a+");
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

function readJsonFile(filename: string): object | null {
  let filePath = filesDir + filename;
  ensureFileExists(filePath);

  let stat = fileIo.statSync(filePath);
  let size = stat.size;
  let buf = new ArrayBuffer(size);
  let fileStream = fileIo.createStreamSync(filePath, "r");
  fileStream.readSync(buf);
  fileStream.close();

  let content = buffer.from(buf, 0).toString();
  try {
    return JSON.parse(content);
  } catch (e) {
    console.error("Error parsing JSON:", e);
    return null;
  }
}

export function userExists(username: string): boolean {
  let filePath = filesDir + username + '.json';
  return fileIo.accessSync(filePath);
}

export function registerUser(userInfo: UserInfo): boolean {
  if (userExists(userInfo.username)) {
    console.error("User already exists");
    return false;
  }
  writeJsonFile(userInfo.username + '.json', userInfo);
  return true;
}

export function getUserInfo(username: string): UserInfo | null {
  if (!userExists(username)) {
    console.error("User does not exist");
    return null;
  }
  return readJsonFile(username + '.json') as UserInfo;
}

export function updateUserInfo(username: string, updatedInfo: Partial<UserInfo>): boolean {
  if (!userExists(username)) {
    console.error(`用户 ${username} 不存在`);
    return false;
  }

  let currentInfo = getUserInfo(username);
  if (!currentInfo) {
    console.error(`无法获取用户 ${username} 的信息`);
    return false;
  }

  // 手动更新对象属性
  let newInfo: UserInfo = {
    username: currentInfo.username,
    password: updatedInfo.password !== undefined ? updatedInfo.password : currentInfo.password,
    whatcanIsay: updatedInfo.whatcanIsay !== undefined ? updatedInfo.whatcanIsay : currentInfo.whatcanIsay
  };

  // 写入更新后的用户信息
  writeJsonFile(username + '.json', newInfo);
  console.info(`用户 ${username} 的信息已更新`);
  return true;
}

export function hashPasswordToHex(password: string, callback: (error: Error | null, result: string | null) => void): void {
  let md = cryptoFramework.createMd('SHA256');

  md.update({ data: new Uint8Array(buffer.from(password, 'utf-8').buffer) }, (err) => {
    if (err) {
      callback(err, null);
      return;
    }

    md.digest((err, digestOutput) => {
      if (err) {
        callback(err, null);
        return;
      }

      // 将 Uint8Array 转换为十六进制字符串
      const hexString = Array.from(digestOutput.data)
        .map(b => b.toString(16).padStart(2, '0'))
        .join('');

      callback(null, hexString);
    });
  });
}

export function checkLogin(checkUser: UserInfo): Promise<boolean> {
  return new Promise((resolve) => {
    if (!userExists(checkUser.username)) {
      resolve(false);
      return;
    }

    let storedInfo = getUserInfo(checkUser.username);
    if (!storedInfo || checkUser.username !== storedInfo.username) {
      resolve(false);
      return;
    }

    hashPasswordToHex(checkUser.password, (error, hashedPassword) => {
      if (error) {
        console.error("密码哈希出错:", error);
        resolve(false);
        return;
      }

      if (storedInfo && hashedPassword === storedInfo.password) {
        resolve(true);
      } else {
        resolve(false);
      }
    });
  });
}