// This file can be replaced during build by using the `fileReplacements` array.
// `ng build --prod` replaces `environment.ts` with `environment.prod.ts`.
// The list of file replacements can be found in `angular.json`.

export const environment = {
  production: false,
  apiEndpoint: 'http://192.168.201.120:3002/api/v1',
  googleUrl: 'https://accounts.google.com/o/oauth2/auth?client_id=1062349073075-3l06qo9t1huckd0d58mr1g6n3h9tpgbm.apps.googleusercontent.com&redirect_uri=http://aggregate.nanba.jp:4202&scope=https://www.googleapis.com/auth/calendar&response_type=code&approval_prompt=force&access_type=offline'
};

/*
 * For easier debugging in development mode, you can import the following file
 * to ignore zone related error stack frames such as `zone.run`, `zoneDelegate.invokeTask`.
 *
 * This import should be commented out in production mode because it will have a negative impact
 * on performance if an error is thrown.
 */
// import 'zone.js/dist/zone-error';  // Included with Angular CLI.
