import * as nodemailer from 'nodemailer';
import { config } from './config';

let transporter: nodemailer.Transporter | null = null;

function getTransporter(): nodemailer.Transporter | null {
  if (!config.mail.user || !config.mail.pass) return null;
  if (transporter) return transporter;

  transporter = nodemailer.createTransport({
    host: config.mail.host,
    port: config.mail.port,
    secure: false,
    auth: {
      user: config.mail.user,
      pass: config.mail.pass,
    },
  });
  return transporter;
}

export async function sendEmail(to: string, subject: string, text: string): Promise<void> {
  const t = getTransporter();

  if (!t) {
    console.log(`[MAIL] (no SMTP configured) To: ${to}\nSubject: ${subject}\n${text}`);
    return;
  }

  try {
    await t.sendMail({
      from: `"${config.mail.fromName}" <${config.mail.fromEmail}>`,
      to,
      subject,
      text,
    });
    console.log(`[MAIL] Sent to ${to}: ${subject}`);
  } catch (err) {
    console.error(`[MAIL] Failed to send to ${to}:`, err);
  }
}
