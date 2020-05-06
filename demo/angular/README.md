# capacitor-facebook-login-tutorial
This is tutorial of using [@rdlabo/capacitor-facebook-login](https://github.com/rdlabo/capacitor-facebook-login).

## DONATE THIS PROJECT
Thanks for considering donate.

If this plugin help you, please share your app income. This help developing this plugin.This also help me easily determine how much time I would spend on the projects each month.


|  | TYPE | AMOUNT | LINK |
|:--:|:--:|:--:|:--:|
| PayPal.me | Once | Any | [Donate](https://www.paypal.me/rdlabo) |
| Paypal | Subscription | $15/month | [Donate](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=JHYSDYQB29MLC) |
| Paypal | Subscription | $30/month | [Donate](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=RCJ8A3KXG928A) |
| Paypal | Subscription | $50/month | [Donate](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=U2RQUKRPDA35C) |


## Step by Step
This tutorial is be step by step using commit history. Title have link of commit. 

### 1. [Initial commit](https://github.com/rdlabo/capacitor-facebook-login-tutorial/commit/41101884ca8626b0abba1496ef96914a13980143)
Created project using type `tabs`.


```bash
$ ionic start --type=angular
```

### 2. [create(auth): frame by using generate command.](https://github.com/rdlabo/capacitor-facebook-login-tutorial/commit/3ca45cdfafe96e9ca55c9c35128b6e7ce4988650)
Generated `page`, `guard`, `service` using Ionic CLI Command.

```bash
$ ionic generate page auth
$ ionic generate guard auth/auth
$ ionic generate service auth/auth
```

### 3. [install @rdlabo/ionic-sub and run formatter](https://github.com/rdlabo/capacitor-facebook-login-tutorial/commit/ce85d576fac639900bae604fe7948a38d302c85e)
Install ionic-sub CLI(This is support development Ionic/Angular) and run formatter. This step is not required.

```bash
$ npm install -g @rdlabo/ionic-sub
$ ionic-sub set all
$ npm run formatter
```

### 4. [install capacitor and facebook-login plugin](https://github.com/rdlabo/capacitor-facebook-login-tutorial/commit/cfedd030daeda017d0175490afcb2589dcb4f259)
Install. 
```bash
$ ionic integrations enable capacitor
$ npm i --save @rdlabo/capacitor-facebook-login
```
If you don't use Ionic Framework, you use command `npx cap init` . More information is [getting-started](https://capacitor.ionicframework.com/docs/getting-started) .


### 5. [Implementation facebook login](https://github.com/rdlabo/capacitor-facebook-login-tutorial/commit/d349e5af4d7b09ee6d2570fcba2a8b9aff249d90)
Implementation.

### 6. [capacitor add ios](https://github.com/rdlabo/capacitor-facebook-login-tutorial/commit/6d17a20ef1e5a710cb437e0146f1501e6189bec5)
Install Command only.

```bash
$ npx cap add ios
```

### 7. [iOS configuration](https://github.com/rdlabo/capacitor-facebook-login-tutorial/commit/7a40cb2273adf8d6cd4ed647b6647870cfdd2fff)

Do [iOS configuration](https://github.com/rdlabo/capacitor-facebook-login#ios-configuration). **You should replace `[APP_ID]` to your Facebook App Id.**

### 8. [capacitor add android](https://github.com/rdlabo/capacitor-facebook-login-tutorial/commit/9a601b8321056f65c8ba3813a1880c6b58262c6e)
Install Command only.

```bash
$ npx cap add android
```

### 9. [Android configuration](https://github.com/rdlabo/capacitor-facebook-login-tutorial/commit/07b48477d301ce2626cbc4f8de7c3379c75367b7)


Do [Android configuration](https://github.com/rdlabo/capacitor-facebook-login#android-configuration). **You should replace `[APP_ID]` to your Facebook App Id.**

### 10. Finished!!
You can Facebook Login with Device!!
If you don't understand how to set APP ID, please check [show example facebook APP_ID](https://github.com/rdlabo/capacitor-facebook-login-tutorial/commit/6c9cc2d60db9ee5f5058af58c545e3c7e6c1b8fd).


