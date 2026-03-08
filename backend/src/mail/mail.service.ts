import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as nodemailer from 'nodemailer';

@Injectable()
export class MailService {
  private transporter: nodemailer.Transporter;

  constructor(private readonly configService: ConfigService) {
    this.transporter = nodemailer.createTransport({
      host: this.configService.get<string>('SMTP_HOST'),
      port: this.configService.get<number>('SMTP_PORT'),
      secure: false, // true for 465, false for other ports
      auth: {
        user: this.configService.get<string>('SMTP_USER') || undefined,
        pass: this.configService.get<string>('SMTP_PASS') || undefined,
      },
    });
  }

  async sendOtp(email: string, otp: string) {
    const mailOptions = {
      from: '"Talk & Earn" <no-reply@talkearn.com>',
      to: email,
      subject: 'Verify your email - Talk & Earn',
      text: `Your verification code is: ${otp}`,
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 10px;">
          <h2 style="color: #4CAF50; text-align: center;">Welcome to Talk & Earn!</h2>
          <p>Thank you for signing up. Please use the following code to verify your email address:</p>
          <div style="background-color: #f9f9f9; padding: 20px; text-align: center; font-size: 24px; font-weight: bold; letter-spacing: 5px; color: #333; border: 1px dashed #ccc; border-radius: 5px; margin: 20px 0;">
            ${otp}
          </div>
          <p>This code will expire in 10 minutes.</p>
          <p style="font-size: 12px; color: #999; margin-top: 30px; text-align: center;">
            If you did not request this code, please ignore this email.
          </p>
        </div>
      `,
    };

    try {
      await this.transporter.sendMail(mailOptions);
      console.log(`[Mail] OTP sent to ${email}`);
    } catch (error) {
      console.error(`[Mail] Error sending email to ${email}:`, error);
    }
  }
}
