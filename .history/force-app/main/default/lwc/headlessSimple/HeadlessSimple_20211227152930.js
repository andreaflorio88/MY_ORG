import { LightningElement, api } from 'lwc';
  
declare default class HeadlessSimple extends LightningElement {
  @api invoke() {
    console.log("Hi, I'm an action.");
  }
}