import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';
import vibrator from '@ohos.vibrator';
import { BusinessError } from '@kit.BasicServicesKit';
import fs from '@ohos.file.fs';
import { Context } from '@kit.AbilityKit';

/** VibrationPlugin **/
export default class VibrationPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;
  private context: Context | null = null;

  constructor() {
  }

  getUniqueClassName(): string {
    return "VibrationPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "vibration");
    this.channel.setMethodCallHandler(this)
    this.context = binding.getApplicationContext();
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
    this.context = null;
  }

  async onMethodCall(call: MethodCall, result: MethodResult): Promise<void> {
    if (call.method == "vibrate") {
      try {
        let args: Map<string, ESObject> = call.args;
        let vibrateEffectObject: Map<string, ESObject> = args.get('vibrateEffect');
        let file: fs.File | null;
        let type: string = vibrateEffectObject.get('type');
        let vibrateEffect: vibrator.VibrateEffect | null = null;
        switch (type) {
          case 'file':
            let hapticFd: Map<string, ESObject> = vibrateEffectObject.get('hapticFd');
            let data: Uint8Array = hapticFd.get('data');
            let cacheDir = this.context?.tempDir;
            file = fs.openSync(cacheDir + `/${new Date().getTime()}.json`, fs.OpenMode.WRITE_ONLY | fs.OpenMode.CREATE);
          // let writeLen = await fs.write(file.fd, content);
            let writeLen = await fs.write(file.fd, data.buffer);
            vibrateEffect = {
              type: 'file',
              hapticFd: {
                fd: file.fd,
                offset: hapticFd.get('offset'),
                length: hapticFd.get('length'),
              },
            };
            break;
          case 'time':
            vibrateEffect = {
              type: 'time',
              duration: vibrateEffectObject.get('duration'),
            };
            break;
          case 'preset':
            vibrateEffect = {
              type: 'preset',
              count: vibrateEffectObject.get('count'),
              effectId: vibrateEffectObject.get('effectId'),
            };
            break;
          default:
            break;
        }
        if (vibrateEffect != null) {
          let vibrateAttribute: vibrator.VibrateAttribute = JSON.parse(args.get('vibrateAttribute'));
          await vibrator.startVibration(vibrateEffect, vibrateAttribute,)
            .then(() => {
              if (file != null) {
                fs.close(file.fd);
              }
              console.info('Succeed in starting vibration');
            }, (error: BusinessError) => {
              console.error(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
            });
        }
        result.success(null)
      }
      catch (err) {
        let e: BusinessError = err as BusinessError;
        result.error(e.code.toString(), e.message, e.stack ?? '');
      }
    } else if (call.method == "cancel") {
      try {
        await vibrator.stopVibration();
        result.success(null)
      }
      catch (err) {
        let e: BusinessError = err as BusinessError;
        result.error(e.code.toString(), e.message, e.stack ?? '');
      }
    } else {
      result.notImplemented()
    }
  }
}