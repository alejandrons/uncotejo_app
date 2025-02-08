import { Table, Column, Model } from 'sequelize-typescript';

@Table({
  tableName: 'users',
})
export default class UserModel extends Model {
  @Column
  name!: string;

  @Column
  email!: string;
}
